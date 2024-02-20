//
//  ConnectedDygmaDevice.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

public struct ConnectedDygmaDevice: Hashable {

    // TODO: Add relevant information, ports, etc
    public var deviceType: DygmaDevice

    public var deviceName: String {
        deviceType.displayName
    }

    public init(deviceType: DygmaDevice) {
        self.deviceType = deviceType
    }

}

extension ConnectedDygmaDevice: Comparable {

    public static func < (lhs: ConnectedDygmaDevice, rhs: ConnectedDygmaDevice) -> Bool {
        lhs.deviceType < rhs.deviceType
    }

}

public extension ConnectedDygmaDevice {

    init?(vendorId: Int, productId: Int) {
        guard let deviceType = DygmaDevice.device(vendorId: vendorId, productId: productId) else {
            return nil
        }

        self.deviceType = deviceType
    }

}
