//
//  MockPeripheral.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import CoreBluetooth
import Foundation

class MockPeripheral: CBPeripheral {
    private let _name: String
    override var name: String? { _name }
    
//    init(name: String) {
//        self._name = name
////        super.init()
//    }

    override var identifier: UUID {
        UUID()
    }
}
