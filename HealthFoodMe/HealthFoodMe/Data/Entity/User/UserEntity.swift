//
//  UserDataEntity.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/21.
//

import Foundation

struct UserEntity: Codable {
    let _id, name: String
    let scrapRestaurants: [String]
}
