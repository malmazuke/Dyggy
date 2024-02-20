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

    func connect() async throws -> KeyboardConnectionStatus

    func disconnect() async throws -> KeyboardConnectionStatus

}

class DefaultKeyboardService: KeyboardService {

    @ObservationIgnored
    @Injected(\.focusAPI) private var focusAPI

    func connect() async throws -> KeyboardConnectionStatus {
        // TODO: Add implementation

        Logger.viewCycle.debug("KeyboardService: Connecting...")

        let connectedDevices = try await focusAPI.find(devices: DygmaDevice.allDevices)
        Logger.viewCycle.debug("Connected devices: \(connectedDevices)")

        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        let isConnected = Bool.random()

        if isConnected {
            Logger.viewCycle.debug("KeyboardService: Connected")

            return .connected
        } else {
            throw Bool.random() ? KeyboardConnectionError.timeout : KeyboardConnectionError.unknown
        }
    }

    func disconnect() async throws -> KeyboardConnectionStatus {
        // TODO: Add implementation

        Logger.viewCycle.debug("KeyboardService: Disconnecting...")

        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        Logger.viewCycle.debug("KeyboardService: Disconnected")

        return .disconnected
    }

}
