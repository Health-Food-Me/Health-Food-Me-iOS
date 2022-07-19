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
    let description: String
    let bloggername: String
    let bloggerlink: String
    let postdate: String
}

