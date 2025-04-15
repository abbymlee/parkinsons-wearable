//
//  PastHistoryView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

struct PastHistoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        } // ZStack
        
    } // body
    
} // PastHistoryView



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
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}





#Preview {
    PastHistoryView()
}
