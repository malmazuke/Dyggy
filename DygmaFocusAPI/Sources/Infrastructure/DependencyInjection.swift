//
//  DependencyInjection.swift
//  
//
//  Created by Mark Feaver on 20/2/2024.
//

import Factory
import ORSSerial

extension Container {

    var deviceService: Factory<DeviceService> {
        self { DefaultDeviceService() }
    }

    var serialPortManager: Factory<ORSSerialPortManager> {
        self { ORSSerialPortManager.shared() }
    }

}
