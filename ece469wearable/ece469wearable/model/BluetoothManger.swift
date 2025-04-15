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

class BluetoothManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    
    @Published var rssiValues: [UUID: NSNumber] = [:]
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripherals: [CBPeripheral] = []
    
    
    @Published var discoveredPeripheralsMock: [PeripheralMock] = []
    @Published var connectedPeripheralsMock: [PeripheralMock] = []

    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        discoveredPeripherals.removeAll()
        rssiValues.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    func connect(to peripheral: CBPeripheral) {
        if !connectedPeripherals.contains(peripheral) {
            centralManager.connect(peripheral, options: nil)
        }
    }

    func disconnect(from peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }

    func isConnected(_ peripheral: CBPeripheral) -> Bool {
        connectedPeripherals.contains(peripheral)
    }
    
    
    
    
    
    
    
    
    
    
    func startScanningMock(){
        discoveredPeripheralsMock.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.discoveredPeripheralsMock.append(PeripheralMock(name: "Place_Holder_Ex1"))
            self.discoveredPeripheralsMock.append(PeripheralMock(name: "Place_Holder_Ex2"))
            self.discoveredPeripheralsMock.append(PeripheralMock(name: "Place_Holder_Ex3"))
        }
    }
    
    func connectMock(to peripheral: PeripheralMock) {
        if !connectedPeripheralsMock.contains(peripheral) {
            connectedPeripheralsMock.append(peripheral)
        }
    }
    
    func disconnectMock(from peripheral: PeripheralMock) {
        connectedPeripheralsMock.removeAll {$0 == peripheral}
    }
    

}










extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth unavailable: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
        rssiValues[peripheral.identifier] = RSSI
    }

    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unnamed Device")")
        if !connectedPeripherals.contains(peripheral) {
            connectedPeripherals.append(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unnamed Device")")
        connectedPeripherals.removeAll { $0.identifier == peripheral.identifier }
    }
}










extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else { return }
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
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error reading value: \(error.localizedDescription)")
            return
        }

        if let value = characteristic.value {
            print("Received value for \(characteristic.uuid): \(value)")
            // Convert the data as needed, e.g., string, integer, etc.
        }
    }
}
