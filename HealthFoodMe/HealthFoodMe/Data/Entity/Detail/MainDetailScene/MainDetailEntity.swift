//
//  MainDetailEntity.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import Foundation

// MARK: - MainDetailEntity
struct MainDetailEntity: Codable {
    let restaurant: Restaurant
    let menu: [Menu]
}

// MARK: - Menu
struct Menu: Codable {
    let id, name: String
    let image: String
    let kcal, per: Int?
    let price: Int
    let isPick: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image, kcal, per, price, isPick
    }
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: String
    let distance: Int
    let name, logo, category: String
    let hashtag: [String]
    let address: String
    let workTime: [String]
    let contact: String
    let isScrap: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case distance, name, logo, category, hashtag, address, workTime, contact, isScrap
    }
}
