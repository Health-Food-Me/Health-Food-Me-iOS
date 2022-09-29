//
//  MenuDataModel.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/06.
//

import Foundation

struct MenuDataModel: Codable {
    let restaurantID: String
    let isPick: Bool
    let memuImageURL: String?
    let menuName: String
    let menuPrice: Int
    let menuKcal: Double?
    let carbohydrates: Int?
    let protein: Int?
    let fat: Int?
    let per: String?
}
