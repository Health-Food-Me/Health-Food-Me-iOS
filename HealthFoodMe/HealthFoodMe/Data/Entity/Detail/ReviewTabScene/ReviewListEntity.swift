//
//  ReviewListEntity.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/19.
//

import Foundation

struct ReviewListEntity: Codable {
    let id, writer, content: String
    let score: Float
    let image: [Image]
    let hashtag: Hashtag
    
    func toDomain() -> ReviewDataModel {
        
        var hashTagList = [String]()
        hashTagList.append(hashtag.taste)
        for tag in hashtag.good {
            hashTagList.append(tag)
        }
        
        var imageList = [String]()
        for img in self.image {
            imageList.append(img.url)
        }
        return ReviewDataModel.init(reviewer: writer,
                                    starRate: score,
                                    tagList: hashTagList,
                                    reviewImageURLList: imageList,
                                    reviewContents: content)
    }
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
