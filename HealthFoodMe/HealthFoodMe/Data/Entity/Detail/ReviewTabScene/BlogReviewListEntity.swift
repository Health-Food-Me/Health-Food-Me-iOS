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
    
    func toDomain() -> [BlogReviewDataModel] {
        var blogTitle: String = ""
        var blogContents: String = ""
        var blogURL: String = ""
        
        var blogReviewList: [BlogReviewDataModel] = []
  
        for item in self.items {
            blogTitle = item.title
            blogContents = item.description
            blogURL = item.link
            blogReviewList.append(BlogReviewDataModel.init(blogReviewTitle: blogTitle,
                                                           blogReviewContents: blogContents,
                                                           blogURL: blogURL))
        }
        return blogReviewList
    }
}

struct Item: Codable {
    let title: String
    let link: String
    let description: String
    let bloggername: String
    let bloggerlink: String
    let postdate: String
}

