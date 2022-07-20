//
//  ReviewDataModel.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/14.
//

import Foundation

struct ReviewDataModel {
    let reviewer: String
    let starRate: Float
    let tagList: [String]
    let reviewImageURLList: [String]?
    let reviewContents: String?
}

struct ReviewCellViewModel {
    var data: ReviewDataModel
    var foldRequired: Bool
}
