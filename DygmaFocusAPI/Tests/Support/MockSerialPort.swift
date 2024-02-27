//
//  File.swift
//  
//
//  Created by Mark Feaver on 23/2/2024.
//

@testable import DygmaFocusAPI
@preconcurrency import ORSSerial

struct MockSerialPort: SerialPort {

    var delegate: ORSSerialPortDelegate?

    var path: String {
        pathHandler
    }

    // MARK: - Handlers

    let pathHandler: String = "/dev/tty.usbmodem2101"
    var openHandler: (@Sendable () -> Void)!
    var closeHandler: (@Sendable () -> Bool)!

    func open() {
        openHandler()
    }

    func close() -> Bool {
        closeHandler()
    }

}

extension MockSerialPort: Equatable {

    static func == (lhs: MockSerialPort, rhs: MockSerialPort) -> Bool {
        lhs.path == rhs.path
    }

}
