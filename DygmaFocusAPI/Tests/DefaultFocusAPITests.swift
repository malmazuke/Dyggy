import Factory
import XCTest
@testable import DygmaFocusAPI

final class DefaultFocusAPITests: XCTestCase {

    var testSubject: DefaultFocusAPI!
    var mockUSBService: MockUSBService!

    override func setUp() async throws {
        try await super.setUp()

        mockUSBService = MockUSBService()

        Container.shared.usbService.register { [unowned self] in
            mockUSBService
        }

        testSubject = DefaultFocusAPI()
    }

    func testFindAllDevices() async throws {
        // GIVEN all devices are connected
        mockUSBService.discoverConnectedDevicesHandler = {
            DygmaDevice.allDevices.map { (vendorId: $0.vendorId, productId: $0.productId) }
        }

        // AND I expect to find four connected devices
        let expectedDevices: Set<ConnectedDygmaDevice> = Set(
            DygmaDevice.allDevices.map { ConnectedDygmaDevice(vendorId: $0.vendorId, productId: $0.productId) }
        )

        // WHEN Focus API attempts to find devices
        let foundDevices = try await testSubject.find(devices: DygmaDevice.allDevices)

        // THEN Devices are found
        XCTAssertEqual(expectedDevices, foundDevices)
    }

}
