import SwiftUI

import SwiftUI

struct BluetoothView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var isLeftStepDetectorConnected = false
    @State private var showConnectionStatus = false
//    @State private var connectedPeripheral: CBPeripheral?

    var body: some View {
        NavigationStack {
            Text("Discovered Devices")
                .font(.headline)
           
            List {
                ForEach(bluetoothManager.discoveredPeripherals) { peripheralInfo in
                    Button(action: {
                        bluetoothManager.connect(peripheralInfo.peripheral)
                    }) {
                        HStack {
                            Text(peripheralInfo.localName)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
//                    .buttonStyle(PlainButtonStyle()) // Makes the button look like plain text
                }
            }
//            .sheet(isPresented: $showConnectionStatus) { // Present the connection status view as a sheet
//                ConnectionStatusView(bluetoothManager: bluetoothManager)
//            }
            
            
            List {
                ForEach(bluetoothManager.discoveredPeripherals.filter { bluetoothManager.connectedDevices.contains($0.peripheral) }) { peripheralInfo in
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                        Button(peripheralInfo.localName) {
                            bluetoothManager.discoveredPeripherals.removeAll { $0.peripheral == peripheralInfo.peripheral }
                        }.foregroundColor(.green)
                    }
                }
            }
            
//            NavigationView {
//                List {
//                    ForEach(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
//                        Button(action: {
//                            bluetoothManager.connect(to: peripheral)
//                            connectedPeripheral = peripheral
//                        }) {
//                            HStack {
//                                Text(peripheral.name ?? "Unknown Device")
//                                Spacer()
//                                if connectedPeripheral == peripheral && bluetoothManager.isConnected(to: peripheral) {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.green)
//                                }
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Nearby Devices")
//            }
            
            
            
            
        }
    }
}


struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView(bluetoothManager: BluetoothManager())
    }
}
