//
//  DeviceService.swift
//  
//
//  Created by Mark Feaver on 20/2/2024.
//

import Factory
import IOKit.usb
import ORSSerial

protocol DeviceService {

    func discoverConnectedDevices() -> [SerialDevice]

}

struct DeviceAttributes {

    let vendorId: Int
    let productId: Int

}

class DefaultDeviceService: DeviceService {

    // MARK: - Private Properties
    @ObservationIgnored
    @Injected(\.serialPortManager) private var serialPortManager

    // MARK: - DeviceService
    func discoverConnectedDevices() -> [SerialDevice] {
        var devices: [SerialDevice] = []

        let availablePorts = serialPortManager.availablePorts
        for port in availablePorts {
            guard let attributes = port.getVendorAndProductId() else {
                continue
            }

            devices.append(.init(vendorId: attributes.vendorId, productId: attributes.productId, path: port.path))
        }

        return devices
    }

}
