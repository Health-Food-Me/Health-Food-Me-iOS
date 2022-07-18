//
//  RestaurantSummaryModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/18.
//

import Foundation

struct RestaurantSummary: Codable {
    let id, name, logo, category: String
    let hashtag: [String]
    let score: Double
    let isScrap: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, logo, category, hashtag, score, isScrap
    }
}
