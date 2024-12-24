//
//  UserDataModel.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//


import Foundation

struct UserDataModel : Codable {
    
    let accesstoken : String?

    enum CodingKeys: String, CodingKey {
        case accesstoken = "access_token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        accesstoken = try? values?.decodeIfPresent(String.self, forKey: .accesstoken)
    }
}

struct UserResult : Codable {
  
    var id : Int?
    var name : String?
    var email : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case email = "Email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? values?.decodeIfPresent(Int.self, forKey: .id)
        name = try? values?.decodeIfPresent(String.self, forKey: .name)
        email = try? values?.decodeIfPresent(String.self, forKey: .email)
    }
    
    init(id: Int = 0, name: String = "", email: String = ""){
        self.id = id
        self.name = name
        self.email = email
    }
}
