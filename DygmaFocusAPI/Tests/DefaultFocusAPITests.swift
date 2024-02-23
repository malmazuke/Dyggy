import Factory
import ORSSerial
import XCTest
@testable import DygmaFocusAPI

final class DefaultFocusAPITests: XCTestCase {

    var testSubject: DefaultFocusAPI!
    var mockDeviceService: MockDeviceService!
    var mockPort: MockSerialPort!

    override func setUp() {
        super.setUp()

        mockDeviceService = MockDeviceService()
        mockPort = MockSerialPort()

        Container.shared.deviceService.register { [unowned self] in
            mockDeviceService
        }

        testSubject = DefaultFocusAPI()
    }

    func testFindAllDevices() {
        // GIVEN all devices are connected
        mockDeviceService.discoverConnectedDevicesHandler = {
            DygmaDevice.allDevices.map { [unowned self] in
                .init(
                    vendorId: $0.vendorId,
                    productId: $0.productId,
                    port: self.mockPort
                )
            }
        }

        // AND I expect to find four connected devices
        let expectedDevices = DygmaDevice.allDevices.compactMap {
            ConnectedDygmaDevice(deviceType: $0, port: mockPort)
        }.sorted()

        // WHEN Focus API attempts to find devices
        let foundDevices = testSubject.find(devices: DygmaDevice.allDevices).sorted()

        // THEN Devices are found
        XCTAssertEqual(expectedDevices, foundDevices)
    }

}
