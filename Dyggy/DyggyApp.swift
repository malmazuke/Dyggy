import SwiftUI
import SwiftData

import SFSafeSymbols

@main
@MainActor
struct DyggyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var menuViewModel = MenuViewModel()

    var body: some Scene {
        MenuBarExtra("Dyggy", systemImage: SFSymbol.suitSpadeFill.rawValue) {
            MenuView()
                .environment(menuViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
