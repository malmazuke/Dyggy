//
//  SerialPort.swift
//
//
//  Created by Mark Feaver on 23/2/2024.
//

import ORSSerial

protocol SerialPort {

    var delegate: ORSSerialPortDelegate? { get set }
    var path: String { get }

    func open()
    func close() -> Bool

}

extension ORSSerialPort: SerialPort { }
