import XCTest
@testable import Focus_API_MacOS

final class DefaultFocusAPITests: XCTestCase {
    
    var testSubject: DefaultFocusAPI!

    override func setUp() async throws {
        testSubject = DefaultFocusAPI()
    }

    func testFindAllDevices() async throws {
        // GIVEN all devices are connected

        // AND I expect to find four connected devices
        let expectedDevices: Set<ConnectedDygmaDevice> = Set(DygmaDevice.allDevices.map { ConnectedDygmaDevice(vendorId: $0.vendorId, productId: $0.productId) })

        // WHEN Focus API attempts to find devices
        let foundDevices = try await testSubject.find(devices: DygmaDevice.allDevices)

        // THEN Devices are found
        XCTAssertEqual(expectedDevices, foundDevices)
    }

}
