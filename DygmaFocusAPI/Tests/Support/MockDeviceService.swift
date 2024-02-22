//
//  MockDeviceService.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

@testable import DygmaFocusAPI

class MockDeviceService: DeviceService {

    var discoverConnectedDevicesHandler: (() -> [SerialDevice])!

    func discoverConnectedDevices() -> [SerialDevice] {
        discoverConnectedDevicesHandler()
    }

}
