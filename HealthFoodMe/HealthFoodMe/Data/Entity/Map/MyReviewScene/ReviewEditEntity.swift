//
//  ReviewEditEntity.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/21.
//

struct ReviewEditEntity: Codable {
    let id, restaurantID, restaurant, writerID: String
        let writer: String
        let score: Double
        let content: String
        let image: [EditImage]
        let taste: String
        let good: [String]

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case restaurantID = "restaurantId"
            case restaurant
            case writerID = "writerId"
            case writer, score, content, image, taste, good
        }
    }

    // MARK: - Image
    struct EditImage: Codable {
        let name: String
        let url: String
        let id: String

        enum CodingKeys: String, CodingKey {
            case name, url
            case id = "_id"
        }
    }
