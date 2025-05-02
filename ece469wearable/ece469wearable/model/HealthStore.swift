//
//  HealthStore.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/21/25.
//

import Foundation
import HealthKit
import Observation

enum HealthError: Error {
    case healthDataNotAvailable
}

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

@Observable
class HealthStore {
    var healthStore: HKHealthStore?
    var steps: [Step] = []
    private var lastError: Error?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.healthDataNotAvailable
        }
    }
    
    
    func requestAuthorization() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
        guard let healthStore = self.healthStore else { return }
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            lastError = error
        }
    }
    
    func fetchSteps(from startDate: Date, to endDate: Date) async -> Int {
        guard let healthStore = self.healthStore else { return -1 }
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, stats, _ in
                if let quantity = stats?.sumQuantity() {
                    let count = Int(quantity.doubleValue(for: HKUnit.count()))
                    continuation.resume(returning: count)
                } else {
                    continuation.resume(returning: 0)
                }
            }
            healthStore.execute(query)
        }
    }

    
    
    func calculateSteps(startDate: Date, endDate: Date) async throws {
        
        guard let healthStore = self.healthStore else { return }
        
        let calendar = Calendar(identifier: .gregorian)
        
        let stepType = HKQuantityType(.stepCount)
        let interval = DateComponents(minute: 1)
        let theseMinutes = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let steps = HKSamplePredicate.quantitySample(type: stepType, predicate:theseMinutes)
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: steps, options: .cumulativeSum, anchorDate: endDate, intervalComponents: interval)
        
        let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
        
        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            if step.count > 0 {
                // add the step in steps collection
                self.steps.append(step)
            }
        }
    }
    
}
