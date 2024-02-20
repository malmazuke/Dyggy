import XCTest
@testable import Focus_API_MacOS

final class DefaultFocusAPITests: XCTestCase {

    var testSubject: DefaultFocusAPI!
    
    override func setUp() async throws {
        testSubject = DefaultFocusAPI()
    }
    
    func testFindDevices() async throws {
        // GIVEN devices are connected
        
        // AND I expect to find four connected devices
        let expectedDevices: Set<FoundDygmaDevice> = [
            FoundDygmaDevice(id: "1"),
            FoundDygmaDevice(id: "2"),
            FoundDygmaDevice(id: "3"),
            FoundDygmaDevice(id: "4"),
        ]
        
        // WHEN Focus API attempts to find devices
        let foundDevices = try await testSubject.find(devices: [.defyWired, .defyWireless, .raiseWired, .raiseWireless])
        
        // THEN Devices are found
        XCTAssertEqual(expectedDevices, foundDevices)
        
    }
    
}
