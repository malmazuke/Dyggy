//
//  ConnectedDygmaDevice.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

public struct ConnectedDygmaDevice: Hashable {

    public var deviceType: DygmaDevice
    public var path: String

    public var deviceName: String {
        deviceType.displayName
    }

    public init(deviceType: DygmaDevice, path: String) {
        self.deviceType = deviceType
        self.path = path
    }

}

extension ConnectedDygmaDevice: Comparable {

    public static func < (lhs: ConnectedDygmaDevice, rhs: ConnectedDygmaDevice) -> Bool {
        lhs.deviceType < rhs.deviceType
    }

}
