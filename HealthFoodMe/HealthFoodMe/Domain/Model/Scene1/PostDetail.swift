//
//  PostDetail.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

// MARK: - PostDetail
struct PostDetail: Codable {
    let onSale, category, id: String
    let price: Int
    let title: String
    let image: [String]
    let view: Int
    let isPriceSuggestion: Bool
    let createdAt: String
    let isLiked: Bool
    let user: User
}

// MARK: - User
struct User: Codable {
    let region, id, name: String
    let profile: String

    enum CodingKeys: String, CodingKey {
        case region
        case id = "_id"
        case name, profile
    }
}
