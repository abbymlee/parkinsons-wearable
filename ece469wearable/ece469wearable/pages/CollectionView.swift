//
//  CollectionView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isCollecting: Bool = false
    
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                    ? [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.3, green: 0.3, blue: 0.3)] // Dark
                    : [Color(red: 0.78, green: 0.88, blue: 1.0), Color(red: 1.0, green: 0.96, blue: 0.88)]  // Light
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Start New Session")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    
                HStack(spacing: 20) {
                    Button(action: resetCollection) {
                        Text("Reset") // Reset
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isCollecting ? Color.gray : Color.blue, lineWidth: 1.5)
                            )
                    }
                    .disabled(isCollecting == true)
                    
                    Button(action: {
                        if isCollecting {
                            isCollecting = false
                        } else {
                            isCollecting = true
                        }
                    }) {
                        Text(isCollecting ? "Stop" : "Start")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
                .padding(.bottom, 25)
                
                Spacer()
            }
            .background(Color.clear)
            .padding()
            
        } // ZStack

    }
    
    
    func resetCollection() {
        // First clear all bluetooth detected preferrals
        // Logic to scan for Bluetooth devices
        print("Resetting Collection ")

    }
}

#Preview {
    CollectionView()
}
