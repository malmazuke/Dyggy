import Factory
import XCTest
@testable import DygmaFocusAPI

final class DefaultFocusAPITests: XCTestCase {

    var testSubject: DefaultFocusAPI!
    var mockDeviceService: MockDeviceService!

    override func setUp() {
        super.setUp()

        mockDeviceService = MockDeviceService()

        Container.shared.deviceService.register { [unowned self] in
            mockDeviceService
        }

        testSubject = DefaultFocusAPI()
    }

    func testFindAllDevices() {
        // GIVEN all devices are connected
        mockDeviceService.discoverConnectedDevicesHandler = {
            DygmaDevice.allDevices.map {
                .init(vendorId: $0.vendorId, productId: $0.productId, path: "/dev/cu.usbmodem2101")
            }
        }

        // AND I expect to find four connected devices
        let expectedDevices = DygmaDevice.allDevices.compactMap {
            ConnectedDygmaDevice(deviceType: $0, path: "/dev/cu.usbmodem2101")
        }.sorted()

        // WHEN Focus API attempts to find devices
        let foundDevices = testSubject.find(devices: DygmaDevice.allDevices).sorted()

        // THEN Devices are found
        XCTAssertEqual(expectedDevices, foundDevices)
    }

}
