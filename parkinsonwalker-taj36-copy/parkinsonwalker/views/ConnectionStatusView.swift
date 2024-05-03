import SwiftUI
import Foundation

// ConnectionStatusView
struct ConnectionStatusView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack { // Changed from HStack to VStack for vertical alignment
            
            if bluetoothManager.left_detector==true{
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Right Step Detector") // Display the local name
                        .foregroundColor(.green)
                }
            }
            ForEach(bluetoothManager.discoveredPeripherals.filter { bluetoothManager.connectedDevices.contains($0.peripheral) }) { peripheralInfo in
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text(peripheralInfo.localName) // Display the local name
                        .foregroundColor(.green)
                }
            }
        }
    }
}

