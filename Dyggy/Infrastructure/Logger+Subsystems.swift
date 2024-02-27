//
//  Logger+Subsystems.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import OSLog

extension Logger {

    static let viewCycle = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "viewcycle")

    static let statistics = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "statistics")

}
