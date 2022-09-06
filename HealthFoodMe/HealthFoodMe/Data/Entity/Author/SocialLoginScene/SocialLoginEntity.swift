//
//  SocialLoginEntity.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/18.
//

import Foundation

struct SocialLoginEntity: Codable {
    let accessToken: String
    let user: User
    let refreshToken: String
}

// MARK: - User
struct User: Codable {
    let id, name, email, agent: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case agent
    }
}
