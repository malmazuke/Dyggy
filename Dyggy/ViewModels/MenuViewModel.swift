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

    // MARK: - Public Properties

    var connectionState: ConnectionState
    var selectedKeyboard: ConnectedDygmaDevice?
    var availableKeyboards: [ConnectedDygmaDevice] = []

    // MARK: - Private Properties

    @ObservationIgnored
    @Injected(\.keyboardService) private var keyboardService

    // MARK: - Initialisers

    init() {
        self.connectionState = .noKeyboardSelected

        self.searchForConnectedKeyboards()
    }

    private func searchForConnectedKeyboards() {
        let keyboards = keyboardService.discoverKeyboards()

        availableKeyboards = keyboards

        switch keyboards.count {
        case Int.min...0:
            connectionState = .noKeyboardConnected
            selectedKeyboard = nil
        case 1:
            let keyboard = keyboards.first!
            selectedKeyboard = keyboard
            connectToSelectedKeyboard()
        default:
            connectionState = .noKeyboardSelected
            selectedKeyboard = nil
        }

    }

}

// MARK: - Actions

extension MenuViewModel {

    func connectToKeyboard(_ keyboard: ConnectedDygmaDevice) {
        selectedKeyboard = keyboard

        connectToSelectedKeyboard()
    }

    func connectToSelectedKeyboard() {
        guard let selectedKeyboard else {
            fatalError("Should always have a selected keyboard if connect called")
        }
        connectionState = .connecting

        Task {
            do {
                let connectionStatus = try await keyboardService.connect(to: selectedKeyboard)
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
