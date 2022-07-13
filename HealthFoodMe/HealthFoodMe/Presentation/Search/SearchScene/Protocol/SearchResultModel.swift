//
//  SearchResultModel.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/12.
//

import Foundation

protocol SearchResultModel { }

struct SearchRecentDataModel: SearchResultModel {
    let searchContent: String
}

struct SearchDataModel: SearchResultModel {
    let isDiet: Bool
    let title: String
}

struct SearchResultDataModel: SearchResultModel {
    let food: String
    let title: String
}
