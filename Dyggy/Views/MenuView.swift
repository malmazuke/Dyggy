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
        switch viewModel.state {
        case .disconnected:
            Button(action: viewModel.connect) {
                Text("Disconnected")
            }
        case .connecting:
            Text("Connecting...")
        case .connected:
            Text("Connected")
        case .error:
            Button(action: viewModel.connect) {
                Text("Error connecting - click to try again")
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
