//
//  DependencyInjection.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import Factory

extension Container {

    var keyboardService: Factory<KeyboardService> {
        Factory(self) { DefaultKeyboardService() }
    }

}
