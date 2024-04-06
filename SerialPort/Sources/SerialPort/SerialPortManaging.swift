//
//  SerialPortManaging.swift
//
//
//  Created by Mark Feaver on 6/4/2024.
//

import Foundation

public protocol SerialPortManaging {

    func listAvailableDevices() async throws -> [SerialDeviceInfo]
    var deviceEvents: AsyncStream<DeviceEvent> { get }

}
