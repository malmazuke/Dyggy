//
//  USBService.swift
//  
//
//  Created by Mark Feaver on 20/2/2024.
//

import Foundation
import IOKit.usb

protocol USBService {

    func discoverConnectedDevices() -> [USBDevice]

}

class DefaultUSBService: USBService {

    func discoverConnectedDevices() -> [USBDevice] {
        var results: [USBDevice] = []

        // Set up a matching dictionary for the IOService matching
        let matchingDict = IOServiceMatching(kIOUSBDeviceClassName) as NSMutableDictionary

        // Get a main port for communication with I/O Kit
        let mainPort: mach_port_t = kIOMainPortDefault

        // Create an iterator for all USB devices
        var iterator: io_iterator_t = 0
        let kernResult = IOServiceGetMatchingServices(mainPort, matchingDict, &iterator)
        guard kernResult == KERN_SUCCESS else {
            // TODO: Throw actual useful errors
            print("Error: Could not create an iterator for matching services (\(kernResult))")
            return results
        }

        // Iterate over all found devices
        while true {
            let device: io_service_t = IOIteratorNext(iterator)
            if device == 0 {
                break
            }

            // Retrieve the device's vendor ID
            let vendorIDRef = IORegistryEntryCreateCFProperty(device, kUSBVendorID as CFString, kCFAllocatorDefault, 0)
            if let vendorIDNum = vendorIDRef?.takeRetainedValue() as? NSNumber {
                let vendorID = vendorIDNum.intValue

                let productIDRef = IORegistryEntryCreateCFProperty(device, kUSBProductID as CFString, kCFAllocatorDefault, 0)
                if let productIDNum = productIDRef?.takeRetainedValue() as? NSNumber {
                    let productID = productIDNum.intValue

                    results.append(.init(vendorId: vendorID, productId: productID))
                }
            }

            // Release the device object
            IOObjectRelease(device)
        }

        // Release the iterator
        IOObjectRelease(iterator)

        return results
    }

}
