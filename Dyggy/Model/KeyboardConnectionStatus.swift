//
//  KeyboardConnectionStatus.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import Foundation

enum KeyboardConnectionStatus {
    case disconnected
    case disconnecting
    case connecting
    case connected
    case error(KeyboardConnectionError)
}

// TODO: Add keyboard statuses
enum KeyboardConnectionError: Error {
    case unknown
    case timeout
}

extension KeyboardConnectionError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .timeout:
            "Timeout"
        case .unknown:
            "Unknown"
        }
    }

}
