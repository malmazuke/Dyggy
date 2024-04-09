//
//  SerialPortManager.swift
//
//
//  Created by Mark Feaver on 6/4/2024.
//

import Foundation
import IOKit.serial
import IOKit.usb

public protocol SerialPortManaging {

    var deviceEvents: AsyncStream<DeviceEvent>? { get }

    func listAvailableDevices() throws -> [SerialDeviceInfo]

}

public class SerialPortManager: SerialPortManaging {

    public var deviceEvents: AsyncStream<DeviceEvent>? = nil

    public func listAvailableDevices() throws -> [SerialDeviceInfo] {
        var devices: [SerialDeviceInfo] = []

        let matchingDictionary = IOServiceMatching(kIOSerialBSDServiceValue)
        var iterator: io_iterator_t = 0
        let kernResult = IOServiceGetMatchingServices(kIOMainPortDefault, matchingDictionary, &iterator)

        guard kernResult == KERN_SUCCESS else {
            throw SerialPortError.failedToEnumerateDevices
        }

        while case let serialService = IOIteratorNext(iterator), serialService != 0 {
            defer { IOObjectRelease(serialService) }

            let deviceInfo = try extractDeviceInfo(from: serialService)
            devices.append(deviceInfo)
        }

        IOObjectRelease(iterator)
        return devices
    }

    private func extractDeviceInfo(from serialService: io_object_t) throws -> SerialDeviceInfo {
        guard let portName = IORegistryEntryCreateCFProperty(serialService, kIOCalloutDeviceKey as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? String else {
            throw SerialPortError.failedToExtractPortName
        }

        let portProperties = extractVendorAndProductIds(from: serialService)

        return SerialDeviceInfo(portName: portName, vendorId: portProperties.vendorId, productId: portProperties.productId)
    }

    private func extractVendorAndProductIds(from device: io_object_t) -> (vendorId: Int?, productId: Int?) {
        var vendorId: Int? = nil
        var productId: Int? = nil
        var parentDevice: io_object_t = 0
        var currentDevice = device

        IOObjectRetain(device) // Ensure the original device is retained during traversal

        while IORegistryEntryGetParentEntry(currentDevice, kIOServicePlane, &parentDevice) == KERN_SUCCESS {
            defer { IOObjectRelease(currentDevice) }
            currentDevice = parentDevice

            if let vendorIdRef = IORegistryEntryCreateCFProperty(currentDevice, kUSBVendorID as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? NSNumber {
                vendorId = vendorIdRef.intValue
            }

            if let productIdRef = IORegistryEntryCreateCFProperty(currentDevice, kUSBProductID as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? NSNumber {
                productId = productIdRef.intValue
            }

            if vendorId != nil && productId != nil {
                break // Exit the loop once both IDs are found
            }
        }

        IOObjectRelease(currentDevice) // Release the last parentDevice obtained in the loop
        return (vendorId, productId)
    }

}
