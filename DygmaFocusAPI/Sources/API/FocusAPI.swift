import Factory
import Observation

public protocol FocusAPI: Actor {

    func find(devices: Set<DygmaDevice>) async -> [ConnectedDygmaDevice]

    func connect(to device: ConnectedDygmaDevice) async throws

    func disconnect() async throws

}

public actor DefaultFocusAPI: FocusAPI {

    // MARK: - Private Properties
    @ObservationIgnored
    @Injected(\.deviceService) private var deviceService

    private var connectedDevice: ConnectedDygmaDevice?

    // MARK: - Initialisers

    public init() {
        // Intentionally left blank
    }

    // MARK: - Public methods

    public func find(devices: Set<DygmaDevice>) async -> [ConnectedDygmaDevice] {
        let allDevices = deviceService.discoverConnectedDevices()

        let connectedDevices: [ConnectedDygmaDevice] = allDevices.compactMap { serialDevice in
            guard let dygmaDevice = DygmaDevice.device(
                vendorId: serialDevice.vendorId,
                productId: serialDevice.productId
            ) else {
                return nil
            }
            return ConnectedDygmaDevice(deviceType: dygmaDevice, port: serialDevice.port)
        }

        return connectedDevices
    }

    public func connect(to device: ConnectedDygmaDevice) async throws {
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    }

    public func disconnect() async throws {
        connectedDevice = nil
    }

}
