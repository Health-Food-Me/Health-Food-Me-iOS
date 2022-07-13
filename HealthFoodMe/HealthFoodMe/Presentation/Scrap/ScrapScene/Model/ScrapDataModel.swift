//
//  ScrapDataModel.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import Foundation
import UIKit

struct ScrapDataModel: Codable {
    let scrapimageUrl: String
    let storeName: String
    let storeLocation: String
}

extension ScrapDataModel {
    static var sampleScrapData: [ScrapDataModel] = [
        ScrapDataModel(scrapimageUrl: "tempBurger", storeName: "써브웨이 동대문역사문화공원역점", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "진짜 맛있는 건강 버거", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "써브웨이 동대문역사문화공원역점", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "진짜 맛있는 건강 버거", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "써브웨이 동대문역사문화공원역점", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "진짜 맛있는 건강 버거", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "써브웨이 동대문역사문화공원역점", storeLocation: "서울시 용산구"),
        ScrapDataModel(scrapimageUrl: "", storeName: "진짜 맛있는 건강 버거", storeLocation: "서울시 용산구")
    ]
}
