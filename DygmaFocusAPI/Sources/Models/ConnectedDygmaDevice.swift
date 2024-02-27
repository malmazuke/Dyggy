//
//  ConnectedDygmaDevice.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

import ORSSerial

public struct ConnectedDygmaDevice: Sendable, Hashable {

    // MARK: Public properties

    public var deviceType: DygmaDevice

    // MARK: Internal properties

    let port: SerialPort

    // MARK: Computed properties

    public var path: String {
        port.path
    }

    public var deviceName: String {
        deviceType.displayName
    }

    init(deviceType: DygmaDevice, port: SerialPort) {
        self.deviceType = deviceType
        self.port = port
    }

    // MARK: - Hashable

    public static func == (lhs: ConnectedDygmaDevice, rhs: ConnectedDygmaDevice) -> Bool {
        lhs.path == rhs.path
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(deviceType)
    }

}

// MARK: - Comparable

extension ConnectedDygmaDevice: Comparable {

    public static func < (lhs: ConnectedDygmaDevice, rhs: ConnectedDygmaDevice) -> Bool {
        lhs.deviceType < rhs.deviceType
    }

}
