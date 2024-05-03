import Foundation
import SwiftUI

class AnalyticsModel: ObservableObject, Identifiable {
    @Published var id = UUID()
    @Published var startTime: Date
    @Published var numStepsMissed: Int
    @Published var stepsTaken: Int
    @Published var isRunning: Bool = false
    @Published var timeArray: [Float] = []
    @Published var stepLengthArray: [Float] = []
    @ObservedObject var bluetoothManager: BluetoothManager

    init(bluetoothManager: BluetoothManager) {
        self.bluetoothManager = bluetoothManager
        startTime = Date()
        self.numStepsMissed = 0
        self.stepsTaken = 0
    }

    init(startTime: Date, numStepsMissed: Int, numStepsTaken: Int, bluetoothManager: BluetoothManager) {
        self.bluetoothManager = bluetoothManager
        self.startTime = startTime
        self.numStepsMissed = numStepsMissed
        self.stepsTaken = numStepsTaken
    }

    func updateData() {
        isRunning = bluetoothManager.isRunning
        
        guard isRunning else { return }
        timeArray = bluetoothManager.timeArray
        stepLengthArray = bluetoothManager.stepLengthArray
        print("Time Array: \(timeArray)")
        print("Step Length Array: \(stepLengthArray)")
    }

    func toggleRunning() {
        isRunning.toggle()
        if !isRunning {
            clearData()
        }
    }

    private func clearData() {
        timeArray.removeAll()
        stepLengthArray.removeAll()
        // Clear arrays in BluetoothManager as well
    }
}
