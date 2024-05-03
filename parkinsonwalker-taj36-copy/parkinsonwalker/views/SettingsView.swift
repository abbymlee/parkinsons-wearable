import SwiftUI

struct SettingsView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State var vibrationStrength: Double = 50
    @State var stepLengthInput: String = ""
    @State var calibratedStepLength: String = "N/A"
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("Vibration Strength: \(Int(vibrationStrength))%")
                    .font(.headline)
                Slider(value: $vibrationStrength, in: 0...100, step: 1)
            }
            .padding()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Avg Step Length (cm)")
                        .font(.headline)
                    TextField("Enter step length", text: $stepLengthInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                Button("Send Length") {
                    calibratedStepLength = stepLengthInput.isEmpty ? "N/A" : stepLengthInput
                    bluetoothManager.sendMessage(stepLengthInput)
                    stepLengthInput = "" // Clear the input box
                    print(calibratedStepLength)
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .padding(.leading, 10)
                .buttonStyle(.borderedProminent) // Make the button more pronounced
            }
            .padding()
            
            Text("Current Calibrated Step Length: \(calibratedStepLength) cm")
                .font(.headline)
            
            Spacer()
            StepRecordingView(bluetoothManager: bluetoothManager)
        }
        .padding()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(bluetoothManager: BluetoothManager())
    }
}
