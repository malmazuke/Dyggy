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

    func openPort()
    func closePort() throws

    func send(command: Command) throws

}

public enum SerialPortError: Error {
    case invalidData
}

extension ORSSerialPort: @unchecked Sendable, SerialPort {

    func openPort() {
        self.open()
    }

    func closePort() throws {
        guard self.close() != false else {
            throw KeyboardConnectionError.unableToClosePort
        }
    }

    func send(command: Command) throws {
        guard let data = command.rawValue.data(using: .utf8) else {
            throw SerialPortError.invalidData
        }

        self.send(data)
    }

}
