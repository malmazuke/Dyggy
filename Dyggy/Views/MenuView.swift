//
//  MenuView.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import SFSafeSymbols
import SwiftUI

struct MenuView: View {

    private var viewModel = MenuViewModel()

    var body: some View {
        switch viewModel.connectionState {
        case .noKeyboardConnected:
            Text("No keyboard detected")
        case .noKeyboardSelected:
            Text("Select keyboard")
        case .disconnected:
            Button(action: viewModel.connectToSelectedKeyboard) {
                Text("Status: Disconnected")
            }
        case .disconnecting:
            Text("Status: Disconnecting")
        case .connecting:
            Text("Status: Connecting...")
        case .connected:
            Text("Status: Connected")
        case .error(let errorMessage):
            Button(action: viewModel.connectToSelectedKeyboard) {
                Text("Error: \(errorMessage)")
            }
        }

        Divider()

        if viewModel.availableKeyboards.count > 0 {
            Menu("Available Keyboards") {
                ForEach(viewModel.availableKeyboards, id: \.deviceType) { device in
                    if let selected = viewModel.selectedKeyboard, selected == device {
                        Button("\(device.deviceName) ✓") {
                            // Deliberately left blank
                        }
                    } else {
                        Button(device.deviceName) {
                            viewModel.connectToKeyboard(device)
                        }
                    }
                }
                .disabled(keyboardSelectionDisabled)
            }
        }

        Button(action: viewModel.selectPrimaryConfig) {
            Text("Select main config")
        }

        Divider()

        Button(action: viewModel.settingsSelected) {
            Text("Settings")
        }

        Button(action: viewModel.quit) {
            Text("Quit")
        }
    }

    private var keyboardSelectionDisabled: Bool {
        switch viewModel.connectionState {
        case .connected, .disconnected, .error, .noKeyboardSelected:
            false
        default:
            true
        }
    }

}

#Preview {
    MenuView()
}
