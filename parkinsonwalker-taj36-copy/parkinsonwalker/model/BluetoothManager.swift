import Foundation
import CoreBluetooth

struct PeripheralCharacteristics {
    var switchCharacteristic: CBCharacteristic?
    var writeCharacteristic: CBCharacteristic?
}

struct PeripheralInfo: Identifiable {
    let id = UUID()
    let peripheral: CBPeripheral
    let localName: String
}


class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    @Published var centralPeripherals: Set<CBPeripheral> = []
    @Published var shouldUpdatePlot: Bool = false
    static var connectedPeripherals: [CBPeripheral: PeripheralCharacteristics] = [:]
    @Published var connectedDevices: [CBPeripheral] = [] // Track connected devices
    @Published var isRunning: Bool = false // Add this line
    @Published var discoveredPeripherals: [PeripheralInfo] = []
    
    @Published var left_detector: Bool = false

    @Published var calibratedLength: Float = 0
    @Published var toPlot = false
    
    @Published var timeArray: [Float] = [] // Arbitrary values
    @Published var stepLengthArray: [Float] = [] // Arbitrary values
    @Published var intCount: Float = -1.0
    
    var readTimer: Timer?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            //print("Bluetooth is not available.")
        }
    }
    
    func BoolToTrue(){
        shouldUpdatePlot = true
    }
    
    func BoolToFalse(){
        shouldUpdatePlot = false
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
               // print(localName)
                let peripheralInfo = PeripheralInfo(peripheral: peripheral, localName: localName)
                if !discoveredPeripherals.contains(where: { $0.peripheral.identifier == peripheral.identifier }) {
                    discoveredPeripherals.append(peripheralInfo)
                }
            }
        }
    
    
    
    
    func connect(_ peripheral: CBPeripheral) {
        if !connectedDevices.contains(peripheral) {
                centralManager.connect(peripheral, options: nil)
            }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        connectedDevices.append(peripheral) // Add the connected device
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let index = connectedDevices.firstIndex(of: peripheral) {
            connectedDevices.remove(at: index) // Remove the disconnected device
            //print("Connection lost with \(peripheral.name ?? "Unnamed device")")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        var peripheralCharacteristics = PeripheralCharacteristics()
        
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: "2A57") || characteristic.uuid == CBUUID(string: "0000AAAA-0000-1000-8000-00805F9B34FB") {
                peripheralCharacteristics.switchCharacteristic = characteristic
            }
            
            if characteristic.uuid == CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E") || characteristic.uuid == CBUUID(string: "0000BBBB-0000-1000-8000-00805F9B34FB") {
                peripheralCharacteristics.writeCharacteristic = characteristic
            }
            
            if characteristic.properties.contains(.notify) || characteristic.properties.contains(.read) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                if let data = "100".data(using: .utf8) {
                    peripheral.writeValue(data, for: characteristic, type: .withResponse)
                }
            }
        }
        
        BluetoothManager.connectedPeripherals[peripheral] = peripheralCharacteristics
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            return
        }
        if let value = characteristic.value {
            let stringValue = String(decoding: value, as: UTF8.self) // Convert Data to String
            print("Received integer: \(stringValue)")
            intCount = Float(stringValue)!
        }
        
        if isRunning==true{
            
            if let value = characteristic.value {
                let stringValue = String(decoding: value, as: UTF8.self) // Convert Data to String
                print("Received time: \(stringValue)")
//                intCount = intCount + 1
                intCount = Float(stringValue)!
                
//                let components = stringValue.split(separator: ",")
//                if components.count == 2, let timeValue = Float(components[0]), let stepLengthValue = Float(components[1]) {
//                    if !timeArray.contains(timeValue) {
//                        timeArray.append(timeValue)
//                        stepLengthArray.append(stepLengthValue)
//                        print("Received time: \(timeValue), step length: \(stepLengthValue) from \(characteristic.uuid.uuidString)")
//                    }
//                }
            }
        }
    }
    
    func startReadTimer() {
        isRunning = true;
        timeArray.removeAll()
        stepLengthArray.removeAll()
        readTimer = Timer.scheduledTimer(withTimeInterval: 50.0, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            for (peripheral, characteristics) in BluetoothManager.connectedPeripherals {
                if let characteristic = characteristics.switchCharacteristic, characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }
    
    func stopReadTimer() {
        isRunning = false;
        readTimer?.invalidate()
        readTimer = nil
    
    }
    
    func sendMessage(_ message: String) {
        guard var messageFloat = Float(message) else {
            print("Error converting message to float")
            return
        }
        
        let messageData = Data(bytes: &messageFloat, count: MemoryLayout<Float>.size)
        calibratedLength = messageFloat
        
        for (peripheral, characteristics) in BluetoothManager.connectedPeripherals {
            if let writeCharacteristic = characteristics.writeCharacteristic {
                if writeCharacteristic.properties.contains(.write) {
                    peripheral.writeValue(messageData, for: writeCharacteristic, type: .withResponse)
                } else if writeCharacteristic.properties.contains(.writeWithoutResponse) {
                    peripheral.writeValue(messageData, for: writeCharacteristic, type: .withoutResponse)
                }
            }
        }
    }
}

extension CBPeripheral: Comparable {
    public static func < (lhs: CBPeripheral, rhs: CBPeripheral) -> Bool {
        lhs.name ?? "unnamed" < rhs.name ?? "unnamed"
    }
}
