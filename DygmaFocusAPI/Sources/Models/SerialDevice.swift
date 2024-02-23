//
//  SerialDevice.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

import ORSSerial

struct SerialDevice {
    let vendorId: Int
    let productId: Int
    let port: SerialPort
}
