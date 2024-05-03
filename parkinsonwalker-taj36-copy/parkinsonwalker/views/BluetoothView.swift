import SwiftUI

import SwiftUI

struct BluetoothView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var isLeftStepDetectorConnected = false
    @State private var showConnectionStatus = false // State to control the sheet presentation

    var body: some View {
        NavigationStack {
            Text("Discovered Devices")
                .font(.headline)
            List {
                // Hardcoded Left Step Detector
                Button(action: {
                    
                  
                    // Mocking a peripheral by using nil as a placeholder
                    bluetoothManager.left_detector = true
        

                    
                }) {
                    HStack {
                        Text("Right Step Detector")
                            .foregroundColor(.blue) // Always green
                        Spacer()
                        if isLeftStepDetectorConnected {
                            
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // Makes the button look like plain text
                
                // List of other discovered peripherals
                ForEach(bluetoothManager.discoveredPeripherals) { peripheralInfo in
                    Button(action: {
                        bluetoothManager.connect(peripheralInfo.peripheral)
                    }) {
                        HStack {
                            Text(peripheralInfo.localName)
                                .foregroundColor(.blue) // Style as needed
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle()) // Makes the button look like plain text
                }
            }
            .sheet(isPresented: $showConnectionStatus) { // Present the connection status view as a sheet
                ConnectionStatusView(bluetoothManager: bluetoothManager)
            }
        }
    }
}


struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView(bluetoothManager: BluetoothManager())
    }
}
