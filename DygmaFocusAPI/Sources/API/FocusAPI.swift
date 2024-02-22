import Factory
import Observation

public protocol FocusAPI {

    func find(devices: Set<DygmaDevice>) -> [ConnectedDygmaDevice]

}

public class DefaultFocusAPI: FocusAPI {

    // MARK: - Private Properties
    @ObservationIgnored
    @Injected(\.deviceService) private var deviceService

    // MARK: - Initialisers

    public init() {
        // Intentionally left blank
    }

    // MARK: - Public methods

    public func find(devices: Set<DygmaDevice>) -> [ConnectedDygmaDevice] {
        let allDevices = deviceService.discoverConnectedDevices()

        let connectedDevices: [ConnectedDygmaDevice] = allDevices.compactMap { serialDevice in
            guard let dygmaDevice = DygmaDevice.device(
                vendorId: serialDevice.vendorId,
                productId: serialDevice.productId
            ) else {
                return nil
            }
            return ConnectedDygmaDevice(deviceType: dygmaDevice, path: serialDevice.path)
        }

        return connectedDevices
    }

}
