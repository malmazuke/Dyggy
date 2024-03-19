//
//  KeyboardConnectionError.swift
//
//
//  Created by Mark Feaver on 18/3/2024.
//

public enum KeyboardConnectionError: Error {

    case unknown
    case noKeyboardDetected
    case unableToClosePort
    case timeout

}
