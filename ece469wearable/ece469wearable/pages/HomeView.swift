//
//  HomeView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var db: DatabaseManager
    @ObservedObject var btManager: BluetoothManager
    
    @Binding var selectedTab: Tab
    
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                    ? [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.3, green: 0.3, blue: 0.3)] // Dark
                    : [Color(red: 0.78, green: 0.88, blue: 1.0), Color(red: 1.0, green: 0.96, blue: 0.88)]  // Light
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Text("My Dashboard")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 20) {
                            // StatCard(title: "Average Step Length", value: "\(db.averageStepLength, specifier: "%.1f") cm")
                            // StatCard(title: "Step Goal Hit Rate", value: "\(db.goalHitPercentage, specifier: "%.1f")%")
                            StatCard(title: "Avg Step Length", value: "21.8 cm")
                            StatCard(title: "Step Goal Hit Rate", value: "92.0%")
                        }
                        .padding(.horizontal)
                        HStack(spacing: 20) {
                            // StatCard(title: "Avg Steps Per Session", value: "\(db.averageNumSteps, specifier: "%.0f") cm")
                            // StatCard(title: "Avg Session Duration", value: "\(db.averageDuration, specifier: "%.1f")%")
                            StatCard(title: "Avg Steps Per Session", value: "46 steps")
                            StatCard(title: "Avg Session Duration", value: "3.4 min")
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 0)
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Connected Devices")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            if btManager.connectedPeripherals.count > 0 {
                                ForEach(btManager.connectedPeripherals, id: \.self) { device in
                                    DeviceCard(name: device.name ?? "Unnamed") {
                                        selectedTab = .bluetooth
                                    }
                                }
                            } else {
                                Button(action: {
                                    selectedTab = .bluetooth
                                }) {
                                    Text("Click to Detect Devices")
                                        .font(.body)
                                        .foregroundColor(.secondary.opacity(0.7))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                                .foregroundColor(.secondary.opacity(0.5))
                                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                        )
                                }
                                .background(Color.clear)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Past Analytics")
                            .font(.headline)
                        
                        ForEach(db.records, id: \.self) { record in
                            AnalyticsHistoryCard(
                                startTime: formatTime(record.startTime),
                                endTime: formatTime(record.endTime),
                                date: formatDate(record.startTime),
                                percent: String(record.percentage)
                            )
                        }
                        
                        AnalyticsHistoryCard(startTime: "9:00 AM", endTime: "9:05 AM", date: "4/9/2025", percent: "94.7")
                        AnalyticsHistoryCard(startTime: "7:30 AM", endTime: "7:35 AM", date: "4/7/2025", percent: "89.3")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    
                } // ScrollView
                
                
            } // VStack
            .padding(.horizontal, 15)
            
        } // ZStack
        
    
    } // body
    
    
} // HomeView


struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
    
}


struct DeviceCard: View {
    let name: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(name)
                    .font(.body)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "dot.radiowaves.left.and.right")
                    .foregroundColor(.blue)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}






#Preview {
    PreviewHomeView()
}

private struct PreviewHomeView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        let mockDB = DatabaseManager()
        mockDB.addReading(DistanceReading(timestamp: Date(), distance: 40.0))
        mockDB.addReading(DistanceReading(timestamp: Date().addingTimeInterval(-60), distance: 38.5))
        mockDB.addReading(DistanceReading(timestamp: Date().addingTimeInterval(-120), distance: 42.3))

        let mockBT = BluetoothManager()
//        let fake1 = PeripheralMock(name: "Place_Holder_Ex1")
//        let fake2 = PeripheralMock(name: "Pl_Hdr_Ex2")
//
//        mockBT.connectedPeripheralsMock = [fake1, fake2]


        return HomeView(db: mockDB, btManager: mockBT, selectedTab: $selectedTab)
    }
}
