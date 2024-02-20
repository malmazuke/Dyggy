//
//  DygmaDevice.swift
//
//
//  Created by Mark Feaver on 20/2/2024.
//

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

    public static var allDevices: Set<DygmaDevice> {
        [.defyWired, .defyWireless, .raiseANSI, .raiseISO]
    }

}
