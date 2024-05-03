import SwiftUI
import Foundation

struct RecordingIndicatorView: View {
    @Binding var isRecording: Bool

    var body: some View {
        HStack {
            if isRecording {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                Text("Recording")
            }
        }
    }
}
