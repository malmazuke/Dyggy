//
//  KeyboardService.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import OSLog

protocol KeyboardService {
    
    func connect() async throws -> KeyboardConnectionStatus
    
    func disconnect() async throws -> KeyboardConnectionStatus
    
}

class DefaultKeyboardService: KeyboardService {
    
    func connect() async throws -> KeyboardConnectionStatus {
        // TODO: Add implementation
        
        Logger.viewCycle.debug("KeyboardService: Connecting...")
        
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        Logger.viewCycle.debug("KeyboardService: Connected")
        
        return .connected
    }
    
    func disconnect() async throws -> KeyboardConnectionStatus {
        // TODO: Add implementation
        
        Logger.viewCycle.debug("KeyboardService: Disconnecting...")
        
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        Logger.viewCycle.debug("KeyboardService: Disconnected")
        
        return .disconnected
    }
    
}
