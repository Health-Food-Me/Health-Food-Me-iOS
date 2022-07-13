//
//  SearchResult.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/12.
//

import Foundation

protocol SearchResult { }

struct SearchRecentDataModel: SearchResult {
    let searchContent: String
}

struct SearchDataModel: SearchResult {
    let isDiet: Bool
    let title: String
}

struct SearchResultDataModel: SearchResult {
    let food: String
    let title: String
}
