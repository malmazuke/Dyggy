//
//  SerialPort.swift
//
//
//  Created by Mark Feaver on 23/2/2024.
//

import ORSSerial

protocol SerialPort: Sendable {

    var delegate: ORSSerialPortDelegate? { get set }
    var path: String { get }
    var baudRate: NSNumber { get set }

    func open()
    func close() -> Bool

    func send(command: Command) throws

}

public enum SerialPortError: Error {
    case invalidData
}

extension ORSSerialPort: @unchecked Sendable, SerialPort {

    func send(command: Command) throws {
        guard let data = command.rawValue.data(using: .utf8) else {
            throw SerialPortError.invalidData
        }

        self.send(data)
    }

}
