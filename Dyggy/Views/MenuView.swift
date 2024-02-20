//
//  MenuView.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import SwiftUI

struct MenuView: View {

    private var viewModel = MenuViewModel()

    var body: some View {
        switch viewModel.connectionState {
        case .noKeyboardConnected:
            Text("Status: No Keyboard Detected")
        case .noKeyboardSelected:
            Text("Select a keyboard below")
        case .disconnected:
            Button(action: viewModel.connect) {
                Text("Status: Disconnected")
            }
        case .disconnecting:
            Text("Status: Disconnecting")
        case .connecting:
            Text("Status: Connecting...")
        case .connected:
            Text("Status: Connected")
        case .error(let errorMessage):
            Button(action: viewModel.connect) {
                Text("Error: \(errorMessage)")
            }
        }

        switch viewModel.keyboardSelectionState {
        case .noneFound:
            Text("No Keyboards Detected")
        case .keyboardsAvailable(let selected, let available):
            List(available, id: \.self) { keyboard in
                Text(keyboard.deviceName)
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
}

#Preview {
    MenuView()
}
