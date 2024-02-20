import Factory
import Observation

public protocol FocusAPI {

    func find(devices: Set<DygmaDevice>) -> Set<ConnectedDygmaDevice>

}

public class DefaultFocusAPI: FocusAPI {

    // MARK: - Private Properties
    @ObservationIgnored
    @Injected(\.usbService) private var usbService

    // MARK: - Initialisers

    public init() {
        // Intentionally left blank
    }

    // MARK: - Public methods

    public func find(devices: Set<DygmaDevice>) -> Set<ConnectedDygmaDevice> {
        let allDevices = usbService.discoverConnectedDevices()

        let foundDevices = allDevices.filter { deviceInfo in
            devices.contains { device in
                device.vendorId == deviceInfo.vendorId && device.productId == deviceInfo.productId
            }
        }

        return Set(foundDevices.compactMap { ConnectedDygmaDevice(vendorId: $0.vendorId, productId: $0.productId) })
    }

}
