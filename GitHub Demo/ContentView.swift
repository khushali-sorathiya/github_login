//
//  ContentView.swift
//  GitHub Demo
//
//  Created by Khushali on 23/12/24.
//  Created by khushali on 23/12/24.
//

import SwiftUI
import CoreData
import NavigationStack

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = GitHubAuthManager.shared
    
    var body: some View {
        NavigationView {
            if !udf.accessToken().isEmpty {
                DashboardVC(accessToken: udf.accessToken())
                    .environmentObject(authManager)
                    .onOpenURL { url in
                        if url.scheme == "myapp" {
                            GitHubAuthManager.shared.handleCallback(url: url)
                        }
                    }
            } else {
                LoginVC()
                    .environmentObject(authManager)
                    .onOpenURL { url in
                        if url.scheme == "myapp" {
                            GitHubAuthManager.shared.handleCallback(url: url)
                        }
                    }
            }
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
