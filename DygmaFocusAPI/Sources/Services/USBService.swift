//
//  USBService.swift
//  
//
//  Created by Mark Feaver on 20/2/2024.
//

protocol USBService {

    func discoverConnectedDevices() -> [(vendorId: Int, productId: Int)]

}

class DefaultUSBService: USBService {

    func discoverConnectedDevices() -> [(vendorId: Int, productId: Int)] {
        // TODO: Make this actually fetch connected devices
        return [(vendorId: DygmaDevice.defyWired.vendorId, productId: DygmaDevice.defyWired.productId)]
    }

}
