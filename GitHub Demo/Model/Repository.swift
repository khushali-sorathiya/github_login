//
//  Repository.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let lastupdate :String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case lastupdate = "updated_at"
    }
}
