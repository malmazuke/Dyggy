//
//  SerialPortConfiguration.swift
//
//
//  Created by Mark Feaver on 6/4/2024.
//

public struct SerialPortConfiguration {

    public let baudRate: BAUDRate
    public let dataBits: DataBits
    public let stopBits: StopBits
    public let parity: Parity
    public let flowControl: FlowControl
    public let readTimeOut: TimeInterval?
    public let writeTimeOut: TimeInterval?

    init(
        baudRate: BAUDRate = .rate9600,
        dataBits: DataBits = .eight,
        stopBits: StopBits = .one,
        parity: Parity = .none,
        flowControl: FlowControl = .none,
        readTimeOut: TimeInterval = nil,
        writeTimeOut: TimeInterval = nil
    ) {
        self.baudRate = baudRate
        self.dataBits = dataBits
        self.stopBits = stopBits
        self.parity = parity
        self.flowControl = flowControl
        self.readTimeOut = readTimeOut
        self.writeTimeOut = writeTimeOut
    }

}
