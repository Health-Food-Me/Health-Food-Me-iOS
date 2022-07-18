//
//  SearchDataModel.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/19.
//

import Foundation

struct SearchDataModel {
    let content: [SearchContentDataModel]
}

struct SearchContentDataModel {
    let id: String
    let title: String
    let isDiet: Bool
}
