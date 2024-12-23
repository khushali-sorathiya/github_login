//
//  AppDelegate.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "myapp" {
            return true
        }
        return false
    }
}
