//
//  MyReviewModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import Foundation

struct MyReviewModel {
    let reviewId: String
    let restaurantName: String
    let starRate: Float
    let tagList: [String]
    let reviewImageURLList: [String]?
    let reviewContents: String?
}

struct MyReviewCellViewModel {
    var data: MyReviewModel
    var foldRequired: Bool
}
