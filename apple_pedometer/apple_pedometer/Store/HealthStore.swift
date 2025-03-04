//
//  HealthStore.swift
//  apple_pedometer
//
//  Created by Emily Shao on 2/20/25.
//
// Asking for permission, giving step

import Foundation
import HealthKit
import Observation

enum HealthError: Error {
    case healthDataUnavailable
}

@Observable
class HealthStore {
    
    var healthStore: HKHealthStore?
    var lastError: Error?
    
    
    @Published var stepCount: Int = 0
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.healthDataUnavailable
        }
        checkHealthStoreAvailability()
    }
    
    private func checkHealthStoreAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            print("Health data is available")
        } else {
            
        }
    }
}
