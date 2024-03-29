//
//  KeyboardConnectionStatus.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import DygmaFocusAPI
import Foundation

enum KeyboardConnectionStatus {

    case disconnected
    case disconnecting
    case connecting
    case connected
    case error(KeyboardConnectionError)

}

extension KeyboardConnectionError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noKeyboardDetected:
            String(localized: "No keyboard detected")
        case .timeout:
            String(localized: "Timeout")
        case .unableToClosePort:
            String(localized: "Error disconnecting keyboard")
        case .unknown:
            String(localized: "Unknown")
        }
    }

}
