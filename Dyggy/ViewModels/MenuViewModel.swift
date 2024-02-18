//
//  DyggyViewModel.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import AppKit
import Combine
import Observation
import OSLog

import Factory

@Observable
class MenuViewModel {
    
    // MARK: - Types
    enum State {
        case disconnected
        case connecting
        case connected
        case error(Error)
        
        static func state(with keyboardConnectionStatus: KeyboardConnectionStatus) -> State {
            switch keyboardConnectionStatus {
            case .disconnected:
                .disconnected
            case .connecting:
                .connecting
            case .connected:
                .connected
            }
        }
    }
    
    // MARK: - Public Properties
    
    var state: State
    
    // MARK: - Private Properties
    
    @ObservationIgnored
    @Injected(\.keyboardService) private var keyboardService
    
    // MARK: - Initialisers
    
    init() {
        self.state = .disconnected
    }
    
}

// MARK: - Actions

extension MenuViewModel {
    
    func connect() {
        state = .connecting
        
        Task {
            do {
                let connectionStatus = try await keyboardService.connect()
                Logger.viewCycle.debug("Connection status: \(String(describing: connectionStatus))")
                
                state = .state(with: connectionStatus)
            } catch {
                Logger.viewCycle.error("\(error.localizedDescription)")
                
                state = .error(error)
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
