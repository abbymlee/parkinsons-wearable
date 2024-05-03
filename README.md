# PTD-Swift-Code

This is the code repository for the IOS app to be paired with the gait-cueing device found here: https://github.com/mayarim/Park_PTD. The app contains three main modules: Bluetooth, Analytics, and Settings. The bluetooth module contains all code to connect the iPhone to the gait-cueing devices. The settings view allows the phone to send calibration settings to the device, as well as start a walking session. The analytics module contains all the code to populate the statistics generated for each walking session. Each specific Swift files' functionalities are detailed below.

To upload this code to the iPhone, you will need to download the Swift code to XCode, which can be downloaded here: https://developer.apple.com/xcode/. Clone this repo using the clone function on Github (should be at the top of the repo), which will generate a zip file. Open the zip file in XCode. Then, thus tutorial: https://www.youtube.com/watch?v=TlgumE2xe_E&ab_channel=CrackingCodewithDave, can be followed, which explains all the licensing and configuring done needed to compile the code from XCode to your iphone.

## AnalyticsModel.swift

Defines an AnalyticsModel class that integrates with a BluetoothManager to track and manage data related to step tracking analytics. The class maintains state information such as start time, steps taken, steps missed, and whether tracking is currently active. It provides functions to update data arrays when the tracking is active, toggle the tracking state, and clear the data arrays when tracking stops.

## BluetoothManager.swift

Defines a BluetoothManager class that manages Bluetooth operations using the CoreBluetooth framework, facilitating the discovery, connection, and communication with BLE peripherals in an iOS application. It handles tasks such as scanning for devices, connecting to peripherals, and managing their services and characteristics. Key features include reading and writing to characteristics, maintaining a timer for periodic data updates, and processing received data for application-specific purposes such as step tracking.

## ContentView.swift

Provides a SwiftUI view for an iOS app that integrates a BluetoothManager to manage Bluetooth connections and functionalities. The ContentView features a tabbed interface with sections for Bluetooth, analytics, and settings, each passing a shared instance of BluetoothManager. It includes a connection status view and a dynamic recording indicator that reflects the ongoing state of Bluetooth operations. The design promotes modularity and reusability of the BluetoothManager across different components of the app.

## AnalyticsView.swift

Provides a SwiftUI view, AnalyticsView, designed for visualizing step tracking data in an iOS application using a Bluetooth-connected device. The view displays a graph plotting step length versus time and a list of recorded sessions detailing total and missed steps. The graph dynamically updates based on data received from the BluetoothManager, and new sessions are recorded and displayed in a list when specific conditions are met. Key functionalities include the real-time updating of data, the ability to visualize it graphically, and session management that captures the details of each tracking session.

## BluetoothView.swift

provides a SwiftUI view, BluetoothView, for managing Bluetooth device interactions in an iOS app. The view lists discovered Bluetooth devices. Users can connect to any of the listed devices by tapping on them. The view also features a .sheet that displays the connection status, triggered by a state variable. This implementation effectively utilizes the BluetoothManager to handle connections and display the current status of devices, providing a user-friendly interface for Bluetooth device management.

## CalibrationView.swift

Deprecated. Not toggled to view in the app.

## ConnectionStatusView.swift

Defines a SwiftUI view, ConnectionStatusView, which provides a visual indicator of the connection status of Bluetooth devices managed by a BluetoothManager. The view uses a vertical stack (VStack) to align elements and shows a green circle next to the name of each connected device, indicating an active connection. This design effectively communicates the current connection status to the user, making it straightforward to see which devices are actively connected within the app's interface.

## RecordingIndicatorView.swift

Presents a RecordingIndicatorView, a simple and functional SwiftUI component designed to visually indicate recording status within an app. The view utilizes a horizontal stack (HStack) to place a red circle next to the text "Recording" whenever the isRecording boolean binding is true, signaling that recording is actively taking place. This design offers a clear, concise visual cue that can be easily integrated into broader app interfaces, enhancing user awareness of recording activities.

## SettingsView.swift

Provides a SettingsView for an iOS app, designed to configure settings related to a connected Bluetooth device via a BluetoothManager. The view allows users to adjust the vibration strength of a device with a slider, input and send an average step length to the device, and displays the currently calibrated step length. Functionalities include updating and clearing the step length input, dynamically updating the displayed calibrated step length, and integration of a step recording view. 

## StepRecordingView.swift

Features a StepRecordingView, a component of an iOS app designed for managing the recording of steps through a connected Bluetooth device. The view uses a RecordingState enum to handle different states of recording—recording, paused, and stopped. Users can start or pause the recording with a "Start Steps" button, which toggles the recording state and timer, and stop the recording using a "Stop Steps" button that prompts a confirmation alert. The buttons are styled dynamically based on their state to visually indicate whether recording is active. This view integrates directly with BluetoothManager to control step data recording and visualization, ensuring seamless user interaction with the device's recording functionalities.
