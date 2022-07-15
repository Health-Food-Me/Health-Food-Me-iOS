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
    let imgUrl: String
    let foodCategory: String
    let storeName: String
    let starRate: Double
    let distance: Int
}

extension SearchResultDataModel {
    static var sampleSearchResultData: [SearchResultDataModel] = [
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50),
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50),
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50),
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50),
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50),
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50),
        SearchResultDataModel(imgUrl: "tempSalady", foodCategory: "샐러드", storeName: "써브웨이 공덕역점", starRate: 2.5, distance: 50)
    ]
}
