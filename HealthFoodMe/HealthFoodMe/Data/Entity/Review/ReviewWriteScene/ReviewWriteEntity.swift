//
//  ReviewWriteEntity.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/18.
//

import Foundation

// MARK: - ReviewWriteEntity

struct ReviewWriteEntity: Codable {
    let restaurant, writer: String
    let score: Int
    let content: String
    let image: [Image]
    let taste: String
    let good: [String]
    let id: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case restaurant, writer, score, content, image, taste, good
        case id = "_id"
        case v = "__v"
    }
}

// MARK: - Image
struct Image: Codable {
    let name: String
    let url: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, url
        case id = "_id"
    }
}

