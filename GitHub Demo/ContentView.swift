//
//  ContentView.swift
//  GitHub Demo
//
//  Created by Khushali on 23/12/24.
//

import SwiftUI
import CoreData
import NavigationStack

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some View {
        NavigationView {
            LoginVC()
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
