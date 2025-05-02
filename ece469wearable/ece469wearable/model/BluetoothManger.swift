//
//  BluetoothManger.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import CoreBluetooth
import Foundation

struct PeripheralMock: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String?
}




class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    
    @Published var rssiValues: [UUID: NSNumber] = [:]
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripherals: [CBPeripheral] = []
    
    @Published var curStep: Float = 0.0

    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        discoveredPeripherals.removeAll()
        rssiValues.removeAll()
        
//        let deviceInfoUUID = CBUUID(string: "180A")
        let deviceInfoUUID = CBUUID(string: "11111111-1111-1111-1111-111111111111")
        centralManager.scanForPeripherals(withServices: [deviceInfoUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
//        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    func connect(to peripheral: CBPeripheral) {
        if !connectedPeripherals.contains(peripheral) {
            print("Connecting to: \(peripheral.identifier.uuidString)")
            centralManager.connect(peripheral, options: nil)
        }
    }

    func disconnect(from peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }

    func isConnected(_ peripheral: CBPeripheral) -> Bool {
        connectedPeripherals.contains(peripheral)
    }
    
    
    
    
    
//    func startScanningMock(){
//        discoveredPeripheralsMock.removeAll()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.discoveredPeripheralsMock.append(PeripheralMock(name: "Place_Holder_Ex1"))
//            self.discoveredPeripheralsMock.append(PeripheralMock(name: "Place_Holder_Ex2"))
//            self.discoveredPeripheralsMock.append(PeripheralMock(name: "Place_Holder_Ex3"))
//        }
//    }
//    
//    func connectMock(to peripheral: PeripheralMock) {
//        if !connectedPeripheralsMock.contains(peripheral) {
//            connectedPeripheralsMock.append(peripheral)
//        }
//    }
//    
//    func disconnectMock(from peripheral: PeripheralMock) {
//        connectedPeripheralsMock.removeAll {$0 == peripheral}
//    }
    
    
    
    
    func sendMessage(_ message: String) {
        guard var messageFloat = Float(message) else {
            print("Error converting message to float")
            return
        }
        
        let messageData = Data(bytes: &messageFloat, count: MemoryLayout<Float>.size)
        
        for peripheral in connectedPeripherals {

            print("looping through connected peripheral named: \(peripheral.name ?? "No Name")")
            
            if let services = peripheral.services {
                for service in services {
                    if let characteristics = service.characteristics {
                        for characteristic in characteristics {
                            print("Characteristic UUID: \(characteristic.uuid)")
                            
                            if characteristic.properties.contains(.write) {
                                peripheral.writeValue(messageData, for: characteristic, type: .withResponse)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
//
//}
//
//
//
//
//
//
//
//
//
//
//extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            startScanning()
//        } else {
//            print("[bt] Bluetooth unavailable: \(central.state.rawValue)")
//        }
        print("[bt] central state powered on")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier })) {
            discoveredPeripherals.append(peripheral)
//            print("[bt] did discover \(peripheral.name ?? "Unnamed Device")")
            
            if let advertisedName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                print("Discovered device with advertised name: \(advertisedName)")
            } else {
                print("Discovered device with no advertised name, using: \(peripheral.name ?? "Unknown")")
            }
            
        }
//        rssiValues[peripheral.identifier] = RSSI
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("discovering services for \(peripheral.name ?? "Unnamed Device")...")
        peripheral.delegate = self
//        peripheral.discoverServices([CBUUID(string: "11111111-1111-1111-1111-111111111111")])
        peripheral.discoverServices(nil)
        
        print("[bt] did connect to \(peripheral.name ?? "Unnamed Device")")
        if !connectedPeripherals.contains(peripheral) {
            connectedPeripherals.append(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("[bt] Disconnected from \(peripheral.name ?? "Unnamed Device")")
        connectedPeripherals.removeAll { $0.identifier == peripheral.identifier }
    }
//}
//
//
//
//
//
//
//
//
//
//
//extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else {
            print("No services discovered for peripheral: \(peripheral.name ?? "Unknown")")
            return
        }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            
            // Optional: auto-read or subscribe to values
            peripheral.readValue(for: characteristic)
            
            if characteristic.uuid.uuidString == "22222222-2222-2222-2222-222222222222" {
                print("Subscribing to \(characteristic.uuid)")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error reading value: \(error.localizedDescription)")
            print("^Error for: \(characteristic.uuid)")
            return
        }

//        if let value = characteristic.value {
//            print("Received value for \(characteristic.uuid): \(value as NSData)")
//            
//            let floatValue = value.withUnsafeBytes {
//                $0.load(as: Float.self)
//            }
//            print("Decoded Float: \(floatValue)")
//        }
        
        if characteristic.uuid.uuidString == "22222222-2222-2222-2222-222222222222" {
            if let value = characteristic.value {
                let stepLength = value.withUnsafeBytes {
                    $0.load(as: Float.self)
                }
                let roundedStepLength = round (stepLength * 100.0) / 100.0
                print("Updated value. Decoded Float: \(roundedStepLength)")
                
                let reading = DistanceReading(timestamp: Date(), distance: roundedStepLength)
                DispatchQueue.main.async {
                    DatabaseManager.shared.addReading(reading)
                    self.curStep = roundedStepLength
                }
            }
        }
    }
}
