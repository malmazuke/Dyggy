public enum DygmaDevice {
    case defyWired
    case defyWireless
    case raiseWired
    case raiseWireless
}

public struct FoundDygmaDevice: Hashable {
    // TODO: Add relevant information, ports, etc
    var id: String
}

public protocol FocusAPI {

    func find(devices: Set<DygmaDevice>) async throws -> Set<FoundDygmaDevice>

}

public class DefaultFocusAPI: FocusAPI {

    public func find(devices: Set<DygmaDevice>) async throws -> Set<FoundDygmaDevice> {
        return Set<FoundDygmaDevice>()
    }

}
