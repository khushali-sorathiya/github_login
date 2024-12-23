//
//  UserDefaults.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import UIKit
import Foundation

let udf : UDF = UDF()

enum DefaultKey : String {
    
    case userName = "user_name"
    case userData = "User_Data"
   
}

public struct UDF {
    
    func setObject(value: Any, key: DefaultKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func removeObject(key: DefaultKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func removeAllObject() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        dictionary.keys.forEach { key in
          defaults.removeObject(forKey: key)
        }
        
    }

    
    func userResult() -> UserResult {
        if let savedData = UserDefaults.standard.data(forKey: DefaultKey.userData.rawValue) {
            let decoder = JSONDecoder()
            if let decodedLanguage = try? decoder.decode(UserResult.self, from: savedData) {
                return decodedLanguage
            }
        }
        return UserResult()
    }
    
   
    
}
