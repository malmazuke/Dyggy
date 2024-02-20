public enum DygmaDevice {
    case defyWired
    case defyWireless
    case raiseANSI
    case raiseISO
    
    var vendorId: Int {
        switch self {
        case .defyWired:
            0x35ef
        case .defyWireless:
            0x35ef
        case .raiseANSI:
            0x1209
        case .raiseISO:
            0x1209
        }
    }
    
    var productId: Int {
        switch self {
        case .defyWired:
            0x0010
        case .defyWireless:
            0x0012
        case .raiseANSI:
            0x2200
        case .raiseISO:
            0x2201
        }
    }
    
    static var allDevices: Set<DygmaDevice> {
        [.defyWired, .defyWireless, .raiseANSI, .raiseISO]
    }

}

public struct ConnectedDygmaDevice: Hashable {

    // TODO: Add relevant information, ports, etc
    var vendorId: Int
    var productId: Int

}

public protocol FocusAPI {

    func find(devices: Set<DygmaDevice>) async throws -> Set<ConnectedDygmaDevice>

}

public class DefaultFocusAPI: FocusAPI {

    public func find(devices: Set<DygmaDevice>) async throws -> Set<ConnectedDygmaDevice> {
        return Set<ConnectedDygmaDevice>()
    }

}
