//
//  MockUSBService.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

@testable import DygmaFocusAPI

class MockUSBService: USBService {

    var discoverConnectedDevicesHandler: (() -> [USBDevice])!

    func discoverConnectedDevices() -> [USBDevice] {
        discoverConnectedDevicesHandler()
    }

}
