//
//  KeyboardConnectionStatus.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

enum KeyboardConnectionStatus {
    case disconnected
    case connecting
    case connected
    case error(KeyboardConnectionError)
}

// TODO: Add keyboard statuses
enum KeyboardConnectionError: Error { }
