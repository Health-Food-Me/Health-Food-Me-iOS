//
//  MyReviewEntity.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import Foundation

// MARK: - Datum
struct MyReviewEntity: Codable {
    let restaurant, restaurnatId: String
    let score: Float
    let content, id: String
    let image: [MyReviewImage]
    let good: [String]
    let taste: String
    
    func toDomain() -> MyReviewModel {
        
        var hashTagList = [String]()
        hashTagList.append(taste)
        for tag in good {
            hashTagList.append(tag)
        }
        
        var imageList = [String]()
        for img in self.image {
            imageList.append(img.url)
        }
        return MyReviewModel.init(reviewId: id, restaurantName: restaurant,
                                  restaurantId: restaurnatId,
                                  starRate: score,
                                  tagList: hashTagList,
                                  reviewImageURLList: imageList,
                                  reviewContents: content)
    }
}

// MARK: - Image
struct MyReviewImage: Codable {
    let name: String
    let url: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, url
        case id = "_id"
    }
}
