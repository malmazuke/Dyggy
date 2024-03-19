import Combine
import Factory
import Observation
import ORSSerial

// TODO: Add back in Actor
public protocol FocusAPI {

    func find(devices: Set<DygmaDevice>) async -> [ConnectedDygmaDevice]

    func connect(to device: ConnectedDygmaDevice) async throws

    func disconnect() async throws

    func send(command: Command) async throws -> Data

}

public class DefaultFocusAPI: NSObject, FocusAPI {

    // MARK: - Private Properties
    @ObservationIgnored
    @Injected(\.deviceService) private var deviceService

    private var connectedDevice: ConnectedDygmaDevice?
    private var connectionContinuation: CheckedContinuation<Void, Error>?
    private var commandContinuation: CheckedContinuation<Data, Error>?

    // MARK: - Initialisers

    public override init() {
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
        try await withCheckedThrowingContinuation { [unowned self] continuation in
            connectedDevice = device
            connectedDevice!.port.delegate = self
            connectedDevice!.port.baudRate = 115200
            connectionContinuation = continuation

            connectedDevice?.port.open()
        }
    }

    public func disconnect() async throws {
        connectedDevice = nil
    }

    public func send(command: Command) async throws -> Data {
        guard let connectedDevice else {
            throw ConnectionError.noKeyboardDetected
        }

        return try await withCheckedThrowingContinuation { [unowned self] continuation in
            commandContinuation = continuation

            do {
                try connectedDevice.port.send(command: command)
            } catch {
                commandContinuation?.resume(throwing: error)
                commandContinuation = nil
            }
        }
    }

}

extension DefaultFocusAPI: ORSSerialPortDelegate {

    public func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        connectedDevice = nil
    }

    public func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        connectionContinuation?.resume()
        connectionContinuation = nil
    }

    public func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        // If we're currently trying to connect
        if let connectionContinuation {
            connectionContinuation.resume(throwing: error)
            self.connectionContinuation = nil
        } else if let commandContinuation {
            commandContinuation.resume(throwing: error)
        }
    }

    public func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        if let commandContinuation {
            commandContinuation.resume(returning: data)
            self.commandContinuation = nil
        }
    }

}
