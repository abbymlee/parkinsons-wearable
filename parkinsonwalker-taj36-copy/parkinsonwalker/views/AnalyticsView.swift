import SwiftUI

struct Session {
    let id = UUID()
    let date: String
    let startTime: String
    let totalSteps: Int
    let missedSteps: Int
}

struct AnalyticsView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var sessions: [Session] = [
           
            Session(date: "2024-04-09", startTime: "10:31 AM", totalSteps: 67, missedSteps: 4),
            Session(date: "2024-03-10", startTime: "09:42 AM", totalSteps: 31, missedSteps: 8)
        ]

    var body: some View {
        VStack {
            Text("Step Length vs. Time")
                .font(.title)
                .padding(.top, 10)

            if !bluetoothManager.timeArray.isEmpty && !bluetoothManager.stepLengthArray.isEmpty {
                let firstTimeValue = CGFloat(bluetoothManager.timeArray[0])
                let maxTimeValue = CGFloat(bluetoothManager.timeArray.max() ?? 1)
                let maxStepLength = CGFloat(bluetoothManager.stepLengthArray.max() ?? 1)
                let xOffset = CGFloat(20) // Offset to move the plot to the right
                
                GeometryReader { geometry in
                    // Draw the X axis
                    Path { path in
                        let xAxisY = geometry.size.height
                        path.move(to: CGPoint(x: xOffset, y: xAxisY))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: xAxisY))
                    }
                    .stroke(Color.white, lineWidth: 1)
                    
                    // Draw the Y axis
                    Path { path in
                        path.move(to: CGPoint(x: xOffset, y: 0))
                        path.addLine(to: CGPoint(x: xOffset, y: geometry.size.height))
                    }
                    .stroke(Color.white, lineWidth: 1)
                    
                    // Draw the plot
                    Path { path in
                        let firstX = xOffset // Start from the right of the Y-axis
                        let firstY = (1 - CGFloat(bluetoothManager.stepLengthArray[0] / Float(maxStepLength))) * geometry.size.height
                        path.move(to: CGPoint(x: firstX, y: firstY))
                        
                        for index in 1..<bluetoothManager.timeArray.count {
                            let x = min(xOffset + (CGFloat(bluetoothManager.timeArray[index]) - firstTimeValue) * (geometry.size.width - xOffset) / (maxTimeValue - firstTimeValue), geometry.size.width)
                            let y = (1 - CGFloat(bluetoothManager.stepLengthArray[index] / Float(maxStepLength))) * geometry.size.height
                            
                            if CGFloat(bluetoothManager.timeArray[index]) > firstTimeValue {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    
                    // Draw the points
                    ForEach(0..<bluetoothManager.timeArray.count, id: \.self) { index in
                        let x = min(xOffset + (CGFloat(bluetoothManager.timeArray[index]) - firstTimeValue) * (geometry.size.width - xOffset) / (maxTimeValue - firstTimeValue), geometry.size.width)
                        let y = (1 - CGFloat(bluetoothManager.stepLengthArray[index] / Float(maxStepLength))) * geometry.size.height
                        
                        if CGFloat(bluetoothManager.timeArray[index]) > firstTimeValue {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 5, height: 5)
                                .position(x: x, y: y)
                        }
                    }
        
                    
                    // Draw the X axis labels
                    Text("Time")
                        .position(x: geometry.size.width / 2, y: geometry.size.height + 20)
                    
                    Text("\(Int(maxTimeValue-firstTimeValue))") // Label for maximum time
                        .position(x: geometry.size.width, y: geometry.size.height + 20)
                    
                    // Draw the Y axis labels
                    Text("0")
                        .position(x: xOffset - 20, y: geometry.size.height)
                    
                    Text("\(Int(maxStepLength))")
                        .position(x: xOffset - 20, y: 0)
                    
                    // Draw the horizontal dotted red line
                    Path { path in
                        path.move(to: CGPoint(x: xOffset, y: geometry.size.height - (CGFloat(bluetoothManager.calibratedLength) / maxStepLength) * geometry.size.height))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - (CGFloat(bluetoothManager.calibratedLength) / maxStepLength) * geometry.size.height))
                    }
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 1, dash: [5]))
                    
                    // Add the Y axis label at the position of the red line
                    let yValueAtRedLine = Int(bluetoothManager.calibratedLength)
                    Text("\(yValueAtRedLine)")
                        .position(x: xOffset - 20, y: geometry.size.height - (CGFloat(bluetoothManager.calibratedLength) / maxStepLength) * geometry.size.height)
                }
                .frame(width: 400, height: 200) // Adjust the width as needed
                .padding(.bottom, 20) // Add padding to move the plot up
            }
            
            Spacer()
        

            Text("Sessions")
                .font(.title)
                .padding(.top, 80)
            
            Spacer()

            List {
                ForEach(sessions, id: \.id) { session in
                    sessionRowView(for: session)
                        .padding(.top, 5) // Adjust the vertical padding here
                }
            }
            
            Spacer()
        }
        .navigationTitle("Analytics")
        .onChange(of: bluetoothManager.toPlot) { newValue in
            if newValue {
                var numMissedSteps: Int = 0 // Initialize the counter
                let numSteps = bluetoothManager.stepLengthArray.count
                        for stepLength in bluetoothManager.stepLengthArray {
                            if stepLength < bluetoothManager.calibratedLength {
                                numMissedSteps += 1 // Increment the counter for each missed step
                            }
                        }
                  //      print("Number of missed steps: \(numMissedSteps)")
               // print(numSteps)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: Date())

                dateFormatter.dateFormat = "hh:mm a"
                let timeString = dateFormatter.string(from: Date())

                let newSession = Session(date: dateString, startTime: timeString, totalSteps: numSteps, missedSteps: numMissedSteps)
                sessions.insert(newSession, at: 0)
                
                
               
                bluetoothManager.toPlot = false
                bluetoothManager.stopReadTimer()
            }
        }
    }

    private func sessionRowView(for session: Session) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.date)
                    .font(.body)
                Text(session.startTime)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
            VStack(alignment: .trailing) {
                Text("\(session.totalSteps) total steps")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(session.missedSteps) missed steps")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical)
    }

}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(bluetoothManager: BluetoothManager())
    }
}
