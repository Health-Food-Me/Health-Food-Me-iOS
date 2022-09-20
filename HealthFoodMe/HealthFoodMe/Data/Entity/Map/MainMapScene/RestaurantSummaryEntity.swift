//
//  RestaurantSummaryEntity.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/20.
//

import Foundation

struct RestaurantSummaryEntity: Codable {
    let id, name, logo: String
    let category: [String]
    let score: Double
    let isScrap: Bool
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, logo, category, score, isScrap, longitude, latitude
    }
}
