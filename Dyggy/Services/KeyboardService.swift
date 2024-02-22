//
//  KeyboardService.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import DygmaFocusAPI
import Factory
import OSLog

protocol KeyboardService {

    func discoverKeyboards() -> [ConnectedDygmaDevice]

    func connect(to keyboard: ConnectedDygmaDevice) async throws -> KeyboardConnectionStatus

    func disconnect(from keyboard: ConnectedDygmaDevice) async throws -> KeyboardConnectionStatus

}

class DefaultKeyboardService: KeyboardService {

    @ObservationIgnored
    @Injected(\.focusAPI) private var focusAPI

    func discoverKeyboards() -> [ConnectedDygmaDevice] {
        focusAPI.find(devices: DygmaDevice.allDevices).sorted()
    }

    func connect(to keyboard: ConnectedDygmaDevice) async throws -> KeyboardConnectionStatus {
        // TODO: Add implementation

        Logger.viewCycle.debug("KeyboardService: Connecting to \(keyboard.deviceName) at path \(keyboard.path)")

        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        let isConnected = Bool.random()

        if isConnected {
            Logger.viewCycle.debug("KeyboardService: Connected to \(keyboard.deviceName)")

            return .connected
        } else {
            throw Bool.random() ? KeyboardConnectionError.timeout : KeyboardConnectionError.unknown
        }
    }

    func disconnect(from keyboard: ConnectedDygmaDevice) async throws -> KeyboardConnectionStatus {
        // TODO: Add implementation

        Logger.viewCycle.debug("KeyboardService: Disconnecting from \(keyboard.deviceName)")

        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        Logger.viewCycle.debug("KeyboardService: \(keyboard.deviceName) disconnected")

        return .disconnected
    }

}
