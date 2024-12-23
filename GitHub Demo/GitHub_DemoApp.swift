//
//  GitHub_DemoApp.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import SwiftUI

@main
struct GitHub_DemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
