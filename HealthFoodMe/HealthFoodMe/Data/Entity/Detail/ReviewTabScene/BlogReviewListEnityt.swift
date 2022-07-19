//
//  File.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/20.
//

import Foundation

struct BlogReviewListEntity: Codable {
    let start, display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let itemDescription, bloggername: String
    let bloggerlink: String
    let postdate: String

    enum CodingKeys: String, CodingKey {
        case title, link
        case itemDescription = "description"
        case bloggername, bloggerlink, postdate
    }
}

