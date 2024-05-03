import SwiftUI

struct CalibrationView: View {
    @State private var message = "" // State variable to hold the text input
    @ObservedObject private var bluetoothManager = BluetoothManager() // Assuming you have a BluetoothManager class

    var body: some View {
        VStack {
            Text("Calibration")
                .font(.title)
            Spacer()
            TextField("Enter message", text: $message) // Text field for input
                .padding()
                .border(Color.gray, width: 1) // Adds a border to the text field
                .cornerRadius(5)
                .padding(.horizontal)
            
            HStack {
                Button("Connect") {
                    // Your existing connect action
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
                
                Button("Vibrate") {
                    // Your existing vibrate action
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            
            Button("Send Message") {
                bluetoothManager.sendMessage(message)
                //print(message)
                message = "" // Optionally clear the message after sending
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
}

struct CalibrationView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationView()
    }
}
