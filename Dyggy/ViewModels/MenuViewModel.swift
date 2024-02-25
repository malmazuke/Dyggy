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
@MainActor
class MenuViewModel {

    // MARK: - Types
    enum ConnectionState: Equatable {
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
    var availableKeyboards: [ConnectedDygmaDevice] = []
    var selectedKeyboard: ConnectedDygmaDevice? {
        didSet {
            guard selectedKeyboard != nil else {
                return
            }

            guard oldValue != selectedKeyboard || connectionState != .connected else {
                Logger.viewCycle.debug("Attempted to connect to an already connected keyboard")
                return
            }

            connectToSelectedKeyboard()
        }
    }

    // MARK: - Private Properties

    @ObservationIgnored
    @Injected(\.focusAPI) private var focusAPI

    // MARK: - Initialisers

    init() {
        self.connectionState = .noKeyboardSelected
        self.searchForConnectedKeyboards()
    }

    private func searchForConnectedKeyboards() {
        let keyboards = focusAPI.find(devices: DygmaDevice.allDevices)

        availableKeyboards = keyboards

        switch keyboards.count {
        case Int.min...0:
            connectionState = .noKeyboardConnected
            selectedKeyboard = nil
        case 1:
            let keyboard = keyboards.first!
            selectedKeyboard = keyboard
        default:
            connectionState = .noKeyboardSelected
            selectedKeyboard = nil
        }

    }

    private func updateConnectionStatus(with keyboardConnectionStatus: KeyboardConnectionStatus) {
        connectionState = .state(with: keyboardConnectionStatus)
    }

    private func updateConnectionStatus(with connectionError: KeyboardConnectionError) {
        connectionState = .error(description: connectionError.errorDescription ?? String(localized: "Unknown"))
    }

}

// MARK: - Actions

extension MenuViewModel {

    func connectToSelectedKeyboard() {
        guard let selectedKeyboard else {
            fatalError("Should always have a selected keyboard if connect called")
        }
        connectionState = .connecting

        Task {
            do {
                try await focusAPI.connect(to: selectedKeyboard)
                Logger.viewCycle.debug("Connection status: \(String(describing: ConnectionState.connected))")

                await MainActor.run {
                    updateConnectionStatus(with: .connected)
                }
            } catch let error as KeyboardConnectionError {
                Logger.viewCycle.error("\(error)")

                await MainActor.run {
                    updateConnectionStatus(with: error)
                }
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
