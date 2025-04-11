//
//  DataCollectionView.swift
//  parkinsonwalker
//
//  Created by Emily Shao on 3/31/25.
//

import SwiftUI

struct DataCollectionView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("Press Me") {
                print("pressing button")
            }.buttonStyle(PlainButtonStyle())
            Spacer()
            ForEach(bluetoothManager.discoveredPeripherals.filter { bluetoothManager.connectedDevices.contains($0.peripheral) }) { peripheralInfo in
                VStack {
                    Text(peripheralInfo.localName)
                    HStack {
                        Button("Start Collection") {
//                            bluetoothManager.sendMessage("20")
                            print("sent message")
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DataCollectionView()
}
