//
//  ScrapListEntity.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/18.
//

import Foundation

struct ScrapListEntity: Codable {
    let _id, name, logo: String
    let score: Double
    let category: String
    let hashtag: [String]
    let address: String
    let latitude, longtitude: Double
    
}
