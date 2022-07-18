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
    let id, social: String
    let v: Int
    let refreshToken: String
    let scrapRestaurants: [String]
    let socialID, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case social
        case v = "__v"
        case refreshToken, scrapRestaurants
        case socialID = "socialId"
        case name
    }
}
