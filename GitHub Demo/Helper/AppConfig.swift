//
//  AppConfig.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//


//MARK: App Static Url
struct AppConfig {
    
    static let isDebug: Bool = {
#if DEBUG
        return true
#else
        return false
#endif
    }()
    
    static let baseUrl: String = {
        return isDebug ? "https://github.com/" : "https://github.com/"
    }()
    
    static let repobaseURL :String = {
        return isDebug ? "https://api.github.com/" : "https://api.github.com/"
    }()
    
    
    static let clientID = "Iv23lirq7KQ5Q8OUG6Ds"
    static let clientSecret = "9acdbcc14b3a375ce59791a9ac5edb99575b6244"
    static let redirectURI = "myapp://callback"
    static let authorizationURL = "login/oauth/authorize"
    static let scope = "repo user"
    
}


enum StringMsg : String {
    
    case bundleId = "demoapp.co.GitHub-Demo"
    
    case wrong = "Something want wrong"
    case noInternet = "No internet connection"
    case allowPermission = "Allow Permission"
    
    
}
