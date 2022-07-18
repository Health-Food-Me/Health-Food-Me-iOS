//
//  ReviewListEntity.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/19.
//

import Foundation

struct ReviewListEntity: Codable {
    let id, writer, content: String
    let score: Double
    let image: [Image]
    let hashtag: Hashtag
}

struct Hashtag: Codable {
    let taste: String
    let good: [String]
}

struct Image: Codable {
    let name: String
    let url: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, url
        case id = "_id"
    }
}
