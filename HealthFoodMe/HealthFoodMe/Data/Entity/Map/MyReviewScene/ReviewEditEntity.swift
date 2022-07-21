//
//  ReviewEditEntity.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/21.
//

struct ReviewEditEntity: Codable {
    let id, restaurant, writer: String
    let score: Double
    let content: String
    let image: [editImage]
    let taste: String
    let good: [String]
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case restaurant, writer, score, content, image, taste, good
        case v = "__v"
    }
}

// MARK: - Image
struct editImage: Codable {
    let name: String
    let url: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, url
        case id = "_id"
    }
}
