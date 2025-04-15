//
//  DatabaseManager.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import Foundation

struct DistanceReading: Identifiable {
    let id = UUID()
    let timestamp: Date
    let distance: Double
}



class DatabaseManager: ObservableObject {
    @Published var distances: [DistanceReading] = []

    func addReading(_ reading: DistanceReading) {
        distances.append(reading)
    }
}

