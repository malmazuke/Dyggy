//
//  DeviceService.swift
//  
//
//  Created by Mark Feaver on 20/2/2024.
//

import Factory
import IOKit.usb
import ORSSerial

protocol DeviceService {

    func discoverConnectedDevices() -> [SerialDevice]

}

struct DeviceAttributes {

    let vendorId: Int
    let productId: Int

}

class DefaultDeviceService: DeviceService {

    // MARK: - Private Properties
    @ObservationIgnored
    @Injected(\.serialPortManager) private var serialPortManager

    // MARK: - DeviceService
    func discoverConnectedDevices() -> [SerialDevice] {
        var devices: [SerialDevice] = []

        let availablePorts = serialPortManager.availablePorts
        for port in availablePorts {
            guard let attributes = port.getVendorAndProductId() else {
                continue
            }

            devices.append(.init(vendorId: attributes.vendorId, productId: attributes.productId, path: port.path))
        }

        return devices
    }

}

private extension ORSSerialPort {

    func getVendorAndProductId() -> DeviceAttributes? {
        var result: DeviceAttributes?

        var iterator: io_iterator_t = 0
        guard IORegistryEntryCreateIterator(self.ioKitDevice,
                                            kIOServicePlane,
                                            IOOptionBits(kIORegistryIterateRecursively + kIORegistryIterateParents),
                                            &iterator) == KERN_SUCCESS else { return nil }

        while result == nil {
            let device = IOIteratorNext(iterator)

            if device == 0 {
                break
            }

            var usbProperties: Unmanaged<CFMutableDictionary>?
            guard IORegistryEntryCreateCFProperties(device, &usbProperties, kCFAllocatorDefault, 0) == KERN_SUCCESS,
                  let properties = usbProperties?.takeRetainedValue() as? [String: Any] else {
                IOObjectRelease(device)
                continue
            }

            if let vendorID = properties[kUSBVendorID as String] as? Int,
               let productID = properties[kUSBProductID as String] as? Int {
                result = .init(vendorId: vendorID, productId: productID)
            }

            IOObjectRelease(device)
        }

        IOObjectRelease(iterator)
        return result
    }
}
