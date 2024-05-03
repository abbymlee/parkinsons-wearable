import SwiftUI

enum RecordingState {
    case recording, paused, stopped
}

struct StepRecordingView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var recordingState: RecordingState = .stopped
    @State private var showConfirmation = false // To control the confirmation alert
    
    
    
    var body: some View {
        VStack {
            // Other UI elements can be added here

            HStack(spacing: 20) {
                Button("Start Steps") {
                    if recordingState == .recording {
                        // If already recording, stop the timer and set state to paused
                        bluetoothManager.stopReadTimer()
                        recordingState = .paused
                    } else {
                        // Start or resume recording steps
                        bluetoothManager.startReadTimer()
                        recordingState = .recording
                    }
                }
                .buttonStyle(RecordingButtonStyle(isActive: recordingState == .recording))

                Button("Stop Steps") {
                    // Show confirmation alert
                    showConfirmation = true
                }
                .buttonStyle(RecordingButtonStyle(isActive: recordingState == .stopped))
                .alert(isPresented: $showConfirmation) {
                    Alert(
                        title: Text("Confirm Stop"),
                        message: Text("Are you sure you want to stop recording steps?"),
                        primaryButton: .destructive(Text("Stop")) {
                            bluetoothManager.toPlot=true
                            print(bluetoothManager.stepLengthArray)
                            recordingState = .stopped
                    
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
    }
}

struct RecordingButtonStyle: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .fontWeight(.bold) // Increase font weight to make it bolder
            .padding()
            .background(isActive ? Color.blue : Color.gray)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct StepRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        StepRecordingView(bluetoothManager: BluetoothManager())
    }
}
