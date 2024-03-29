//
//  DependencyInjection.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import DygmaFocusAPI
import Factory

extension Container {

    var focusAPI: Factory<FocusAPI> {
        self { DefaultFocusAPI() }
    }

}
