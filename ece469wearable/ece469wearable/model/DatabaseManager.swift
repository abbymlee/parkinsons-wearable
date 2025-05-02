//
//  DatabaseManager.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import Foundation
import HealthKit

struct DistanceReading: Identifiable {
    let id = UUID()
    let timestamp: Date
    let distance: Float
}

struct SessionInfo: Identifiable, Hashable {
    let id = UUID()
    let startTime: Date
    let endTime: Date
    let steps: Int
    let percentage: Float
}

@MainActor
class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    @Published var healthStore = HealthStore()
    @Published var distances: [DistanceReading] = []
    @Published var records: [SessionInfo] = []
    
    private var startDate: Date?
    private var endDate: Date?
    private var currentStateSteps: Int = 0
    var currentMissedSteps: Int = 0
//    @State private var isRecording: Bool = false
    
    init() {}

    func fetchSteps() async {
        await healthStore.requestAuthorization()
        do {
            try await healthStore.calculateSteps(startDate: startDate!, endDate: endDate!)
            
            guard let lastStep = self.healthStore.steps.last else {
                print("No steps to process")
                currentStateSteps += 12
                return
            }
            currentStateSteps += lastStep.count
        } catch {
            print("Error fetching steps: \(error)")
        }
    }

    func addReading(_ reading: DistanceReading) {
        distances.append(reading)
        
    }
    
    func publishToFirebase() {
        
    }
    
    func startSession(timestamp: Date) {
        startDate = timestamp
    }
    
    func pauseSession(timestamp: Date) async {
        endDate = timestamp
        await fetchSteps()
    }
    
    func endSession(timestamp: Date) async{
        endDate = timestamp
        await fetchSteps()
        
        print(currentStateSteps)
        print(currentMissedSteps)
        
        
        
        records.append(SessionInfo(startTime: startDate!, endTime: endDate!, steps: currentStateSteps, percentage: Float((currentStateSteps-currentMissedSteps)/currentStateSteps)))
        records.sort { $0.startTime > $1.startTime }
        print("Recorded: \(records)")
        
        distances = []
        currentStateSteps = 0;
        currentMissedSteps = 0;
        
    }
    
    
}

