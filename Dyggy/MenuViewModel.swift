//
//  DyggyViewModel.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import Combine
import Observation
import OSLog

@Observable
class MenuViewModel {
    
    enum State {
        case disconnected
        case connecting
        case connected
        case error(Error)
    }
    
    var state: State
    
    init() {
        self.state = .disconnected
    }
    
}

// MARK: - Actions

extension MenuViewModel {
    
    func connect() {
        Logger.viewCycle.debug("Connect selected")
    }
    
    func selectPrimaryConfig() {
        Logger.viewCycle.debug("Select Primary Config selected")
    }
    
    func settingsSelected() {
        Logger.viewCycle.debug("Settings selected")
    }
    
    func quit() {
        Logger.viewCycle.debug("Quit selected")
    }
    
}
