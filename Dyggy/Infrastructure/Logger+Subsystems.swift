//
//  Logger+Subsystems.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}
