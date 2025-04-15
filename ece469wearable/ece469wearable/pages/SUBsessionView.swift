//
//  SUBsessionView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI
import Charts

struct SUBsessionView: View {
    @ObservedObject var db: DatabaseManager
    
    var body: some View {
        Chart(db.distances.suffix(50)) { reading in  // show only latest 50
            LineMark(
                x: .value("Time", reading.timestamp),
                y: .value("Distance", reading.distance)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.blue)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 250)
        .padding(.horizontal, 40)
    }
}

#Preview {
    let mockDB = DatabaseManager()
    mockDB.addReading(DistanceReading(timestamp: Date(), distance: 42.0))
    mockDB.addReading(DistanceReading(timestamp: Date().addingTimeInterval(-1), distance: 26.5))
    mockDB.addReading(DistanceReading(timestamp: Date().addingTimeInterval(-2), distance: 33.2))
    
    return SUBsessionView(db: mockDB)
}
