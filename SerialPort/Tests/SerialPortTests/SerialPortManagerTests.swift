import XCTest
@testable import SerialPort

final class SerialPortManagerTests: XCTestCase {

    // TODO: For now this requires a serial device to actually be connected, and is specific to my machine
    func testSerialPortManager() throws {
        let serialPortManager = SerialPortManager()

        let devices = try! serialPortManager.listAvailableDevices()

        XCTAssertEqual(devices.count, 2)
    }

}
