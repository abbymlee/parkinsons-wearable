import SwiftUI

enum Tabs {
    case bluetooth
    case calibration
    case analytics
    case settings
}

struct ContentView: View {
    @State private var selection: Tabs = .bluetooth
    @StateObject private var bluetoothManager = BluetoothManager() // Create a single instance of BluetoothManager
    @State private var isRecording = false // Track recording state

    var body: some View {
        VStack {
//            ConnectionStatusView(bluetoothManager: bluetoothManager) // Display the connection status
        
            RecordingIndicatorView(isRecording: $isRecording)
                .padding()
                .onReceive(bluetoothManager.$isRunning) { newValue in
                    isRecording = newValue
                }
            
            TabView(selection: $selection) {
                BluetoothView(bluetoothManager: bluetoothManager) // Pass the BluetoothManager instance
                    .tabItem { Label("Bluetooth", systemImage: "antenna.radiowaves.left.and.right") }
                    .tag(Tabs.bluetooth)
//                CalibrationView()
//                    .tabItem { Label("Calibration", systemImage: "smiley") }
//                    .tag(Tabs.calibration)
                AnalyticsView(bluetoothManager: bluetoothManager) // Pass the BluetoothManager instance
                // pass in analystics model instance to reference triggers (do not trigger views from outside of the view itself)
                    .tabItem { Label("Analytics", systemImage: "chart.bar") }
                    .tag(Tabs.analytics)
                SettingsView(bluetoothManager: bluetoothManager) // Pass the BluetoothManager instance
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .tag(Tabs.settings)
                DataCollectionView(bluetoothManager: bluetoothManager) // Pass the BluetoothManager instance
                    .tabItem { Label("Collect", systemImage: "triangle.fill") }
                    .tag(Tabs.settings)
            }
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
