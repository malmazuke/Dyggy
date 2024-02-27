//
//  DygmaDevice.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

public enum DygmaDevice: Sendable {
    case defyWired
    case defyWireless
    case raiseANSI
    case raiseISO
}

extension DygmaDevice: Comparable {

    private var sortOrder: Int {
        switch self {
        case .defyWired:
            return 0
        case .defyWireless:
            return 1
        case .raiseANSI:
            return 2
        case .raiseISO:
            return 3
        }
    }

    public static func < (lhs: DygmaDevice, rhs: DygmaDevice) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

}

extension DygmaDevice {

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

    public static var allDevices: Set<DygmaDevice> {
        [.defyWired, .defyWireless, .raiseANSI, .raiseISO]
    }

    static func device(vendorId: Int, productId: Int) -> DygmaDevice? {
        return allDevices.first { $0.vendorId == vendorId && $0.productId == productId }
    }

}

extension DygmaDevice {

    var displayName: String {
        switch self {
        case .defyWired:
            String(localized: "Dygma Defy (Wired)")
        case .defyWireless:
            String(localized: "Dygma Defy (Wireless)")
        case .raiseANSI:
            String(localized: "Dygma Raise (ANSI)")
        case .raiseISO:
            String(localized: "Dygma Raise (ISO)")
        }
    }

}
