//
//  Item.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
