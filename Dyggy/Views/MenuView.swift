//
//  MenuView.swift
//  Dyggy
//
//  Created by Mark Feaver on 17/2/2024.
//

import DygmaFocusAPI
import SFSafeSymbols
import SwiftUI

@MainActor
struct MenuView: View {

    @Environment(MenuViewModel.self) var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        
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
            Picker("Available Keyboards", selection: $viewModel.selectedKeyboard) {
                ForEach(viewModel.availableKeyboards, id: \.deviceType) { device in
                    Text(device.deviceName)
                    .tag(device as ConnectedDygmaDevice?)
                }
            }
            .disabled(keyboardSelectionDisabled)
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
        .environment(MenuViewModel())
}
