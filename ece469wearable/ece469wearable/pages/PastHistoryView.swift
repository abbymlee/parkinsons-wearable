//
//  PastHistoryView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

struct PastHistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var db: DatabaseManager
    
//    @Binding var selectedTab: Tab
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                   ? [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.3, green: 0.3, blue: 0.3)]  // Dark mode
                   : [Color(red: 0.85, green: 0.93, blue: 1.0), Color(red: 1.0, green: 0.96, blue: 0.88)]  // Light mode
                  ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Text("Past Analytics")
                    .font(.largeTitle.bold())
                
                ForEach(db.records, id: \.self) { record in
                    AnalyticsHistoryCard(
                        startTime: formatTime(record.startTime),
                        endTime: formatTime(record.endTime),
                        date: formatDate(record.startTime),
                        percent: String(record.percentage * 100)
                    )
                }
                
                AnalyticsHistoryCard(startTime: "9:00 AM", endTime: "9:05 AM", date: "4/9/2025", percent: "94")
                AnalyticsHistoryCard(startTime: "7:30 AM", endTime: "7:35 AM", date: "4/7/2025", percent: "90")
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        } // ZStack
        
    } // body
    
} // PastHistoryView

func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "m/d/yyyy"
    return formatter.string(from: date)
}



struct AnalyticsHistoryCard: View {
    let startTime: String
    let endTime: String
    let date: String   // e.g., "Alert" or "Clear"
    let percent: String     // system name of icon

    var body: some View {
        HStack {
            // Left: Start time and status
            VStack(alignment: .leading, spacing: 4) {
                Text(startTime)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Center: Stylized graph
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 40)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.6), .blue.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
//                .onTapGesture { selectedTab = .history }

            Spacer()

            // Right: End time and status
            VStack(alignment: .trailing, spacing: 4) {
                Text(endTime)
                    .font(.headline)
                    .foregroundColor(.primary)
                HStack(spacing: 4) {
                    Text("\(percent)%")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}





#Preview {
    let mockDB = DatabaseManager()
    PastHistoryView(db: mockDB)
}
