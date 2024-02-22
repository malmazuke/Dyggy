//
//  DependencyInjection.swift
//  
//
//  Created by Mark Feaver on 20/2/2024.
//

import Factory

extension Container {

    var deviceService: Factory<DeviceService> {
        self { DefaultDeviceService() }
    }

}
