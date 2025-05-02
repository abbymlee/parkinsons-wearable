//
//  BluetoothView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var db: DatabaseManager
    @ObservedObject var btManager: BluetoothManager
    
    @State private var isSearching: Bool = false
    @State private var selectedDevice: CBPeripheral? = nil
    @State private var selectedDeviceMock: PeripheralMock? = nil
    
    
    // main view
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
            
            
            VStack(spacing: 10) {
                
                HStack(spacing: 8) {
                    Text(isSearching ? "Searching for Devices..." : "Click Refresh to Search")
                        .font(.title3)
                        .foregroundColor(.primary)
                    if isSearching {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    }
                }
                .padding(.top, 15)
                
                // Scrolling popout - took out
                scrollSection
                
                // Buttons - took out section since it was too long
                buttonSection
                
                
            } // VStack
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } // ZStack
        
    }

    
    private var connectedDevicesSection: some View {
        VStack(alignment: .leading) {
            Text("Connected Devices")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(btManager.connectedPeripherals, id: \.self) { device in
                BluetoothDeviceCard(
                    name: device.name ?? "Unnamed Device",
                    isSelected: selectedDevice == device,
                    signalIcon: signalStrength(for: "Connected Device")
                ) {
                    if selectedDevice == device {
                        selectedDevice = nil
                    } else {
                        selectedDevice = device
                    }
                }
            }
            
            Spacer()

        }
    }
    
    private var nearbyDevicesSection: some View {
        ForEach(btManager.discoveredPeripherals, id: \.self) { device in
            if !btManager.connectedPeripherals.contains(device) {
                BluetoothDeviceCard(
                    name: device.name ?? "Unnamed Device",
                    isSelected: selectedDevice == device,
                    signalIcon: signalStrength(for: device.name ?? "Unnamed Device")
                ) {
                    if selectedDevice == device {
                        selectedDevice = nil
                    } else {
                        selectedDevice = device
                    }
                }
            }
        }
    }
    
    private var scrollSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                if btManager.connectedPeripherals.count > 0 {
                    connectedDevicesSection
                }
                
                Text("Nearby Devices")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                if btManager.discoveredPeripherals.count > 0 {
                    nearbyDevicesSection
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.2), radius: 12, x: 0, y: 0)
            )
            .padding()
            .frame(maxWidth: .infinity)
            
        }
    }
    
    private var buttonLabel: String {
        guard let device = selectedDevice else { return "Connect" }
        return btManager.connectedPeripherals.contains(device) ? "Disconnect" : "Connect"
    }
    
    private var buttonSection: some View {
        HStack(spacing: 20) {
            Button(action: refreshDevices) {
                Text("Refresh")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 1.5)
                    )
            }
            
            Button(action: {
                if let device = selectedDevice {
                    if btManager.connectedPeripherals.contains(device) {
                        disconnectFromDevice(device)
                    } else {
                        connectToDevice(device)
                    }
                }
            }) {
                Text(buttonLabel)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedDevice != nil ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(selectedDevice == nil)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 25)
    }
    
    
    // Dummy Signal Strength Function
    func signalStrength(for device: String) -> String {
        switch device {
            case "Connected Device": return "dot.radiowaves.left.and.right"
            case "Device 1": return "wifi.exclamationmark"
            case "Device 2": return "wifi.slash"
            default: return "wifi"
        }
    }
    
    func refreshDevices() {
        // First clear all bluetooth detected preferrals
        // Logic to scan for Bluetooth devices
        print("[view] Scanning for Bluetooth devices... ")
              
        isSearching = true
        btManager.startScanning()
        selectedDevice = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            btManager.stopScanning()
            isSearching = false
        }
    }
    
    func connectToDevice(_ device: CBPeripheral) {
        // Logic to initiate connection
        print("[view] Connecting to device... \(device.name ?? "Unnamed Device")")
        
        btManager.connect(to: device)
        selectedDevice = nil
    }
    
    func disconnectFromDevice(_ device: CBPeripheral) {
        // your logic here
        print("[view] Disconnecting from device... \(device.name ?? "Unnamed Device")")
        
        btManager.disconnect(from: device)
        selectedDevice = nil
    }
}

struct BluetoothDeviceCard: View {
    let name: String
    let isSelected: Bool
    let signalIcon: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(name)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: signalIcon)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}








#Preview {
    PreviewBluetoothView()
}

private struct PreviewBluetoothView: View {
    @State private var selectedTab: Tab = .bluetooth
    
    var body: some View {
        let mockDB = DatabaseManager()
        mockDB.addReading(DistanceReading(timestamp: Date(), distance: 40.0))
        mockDB.addReading(DistanceReading(timestamp: Date().addingTimeInterval(-60), distance: 38.5))
        mockDB.addReading(DistanceReading(timestamp: Date().addingTimeInterval(-120), distance: 42.3))

        let mockBT = BluetoothManager()

        return BluetoothView(db: mockDB, btManager: mockBT)
    }
}
