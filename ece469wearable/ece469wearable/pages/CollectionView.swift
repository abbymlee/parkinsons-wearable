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
    @State private var reset: Bool = true
    
    @ObservedObject var db: DatabaseManager
    @ObservedObject var btManager: BluetoothManager
    
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
                Text(reset ? "Start New Walk" : "Walk In Progress")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    
                HStack(spacing: 20) {
                    Button(action: endCollection) {
                        Text("End Walk") // Reset
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isCollecting ? Color.gray : Color.blue, lineWidth: 1.5)
                            )
                    }
                    .disabled(isCollecting == true)
                    
                    Button(action: { if(isCollecting) {
                        pauseCollection()
                    } else {
                        startCollection()
                    }
                    }) {
                        Text(isCollecting ? "Pause" : "Start")
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
                
                if (btManager.curStep > 0 && isCollecting) {
                    Text("Step Length: \(String(format: "%.2f", btManager.curStep))")
                }
                
                if btManager.curStep < 0 {
                    Text("Missed Step!")
                        .foregroundStyle(.red)
                }
                
                    
                
                Spacer()
            }
            .background(Color.clear)
            .padding()
            
        } // ZStack

    }
    
    
    func resetCollection() {
        // First clear all bluetooth detected preferrals
        // Logic to scan for Bluetooth devices
        print("[collect] Resetting collection...")
        
        isCollecting = false
        reset = true
    }
    
    
    func startCollection() {
        // First clear all bluetooth detected preferrals
        // Logic to scan for Bluetooth devices
        print("[collect] Starting collection... ")

        isCollecting = true
        reset = false
        btManager.sendMessage("2")
        db.startSession(timestamp: Date())
        
    }
    
    func pauseCollection() {
        print("[collect] Pausing collection...")
           
        isCollecting = false
        btManager.sendMessage("4")
        Task {
            await db.pauseSession(timestamp: Date())
        }
    }
    
    func endCollection() {
        print("[collect] Ending collection...")
        isCollecting = false
        reset = true
        
        btManager.sendMessage("3")
        Task {
            await db.endSession(timestamp: Date())
        }
    }
}

#Preview {
    let mockDB = DatabaseManager()
    let mockBT = BluetoothManager()
    return CollectionView(db: mockDB, btManager: mockBT)
}
