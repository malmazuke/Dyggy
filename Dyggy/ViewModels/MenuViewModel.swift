//
//  DyggyViewModel.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import AppKit
import Combine
import DygmaFocusAPI
import Observation
import OSLog

import Factory

@Observable
class MenuViewModel {

    // MARK: - Types
    enum ConnectionState {
        case noKeyboardConnected
        case noKeyboardSelected
        case disconnected
        case disconnecting
        case connecting
        case connected
        case error(description: String)

        static func state(with keyboardConnectionStatus: KeyboardConnectionStatus) -> ConnectionState {
            switch keyboardConnectionStatus {
            case .disconnected:
                .disconnected
            case .disconnecting:
                .disconnecting
            case .connecting:
                .connecting
            case .connected:
                .connected
            case .error(let error):
                .error(description: error.localizedDescription)
            }
        }
    }

    enum KeyboardSelectionState {
        case noneFound
        case keyboardsAvailable(selected: ConnectedDygmaDevice?, available: [ConnectedDygmaDevice])
    }

    // MARK: - Public Properties

    var connectionState: ConnectionState
    var keyboardSelectionState: KeyboardSelectionState

    // MARK: - Private Properties

    @ObservationIgnored
    @Injected(\.keyboardService) private var keyboardService

    // MARK: - Initialisers

    init() {
        self.connectionState = .disconnected
        self.keyboardSelectionState = .noneFound

        self.searchForConnectedKeyboards()
    }

    private func searchForConnectedKeyboards() {
        let keyboards = keyboardService.discoverKeyboards()

        guard keyboards.count > 0 else {
            connectionState = .noKeyboardConnected
            keyboardSelectionState = .noneFound
            return
        }

        keyboardSelectionState = .keyboardsAvailable(selected: nil, available: keyboards)
    }

}

// MARK: - Actions

extension MenuViewModel {

    func connect() {
        connectionState = .connecting

        Task {
            do {
                // TODO: Actually connect to the selected keyboard
                let keyboard = ConnectedDygmaDevice(deviceType: .defyWired)

                let connectionStatus = try await keyboardService.connect(to: keyboard)
                Logger.viewCycle.debug("Connection status: \(String(describing: connectionStatus))")

                connectionState = .state(with: connectionStatus)
            } catch let error as KeyboardConnectionError {
                Logger.viewCycle.error("\(error)")

                connectionState = .error(description: error.errorDescription ?? String(localized: "Unknown"))
            }
        }
    }

    func selectPrimaryConfig() {
        Logger.viewCycle.debug("Select Primary Config selected")
    }

    func settingsSelected() {
        Logger.viewCycle.debug("Settings selected")
    }

    func quit() {
        NSApplication.shared.terminate(self)
    }

}
