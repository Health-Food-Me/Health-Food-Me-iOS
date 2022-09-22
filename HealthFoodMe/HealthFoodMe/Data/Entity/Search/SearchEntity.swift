//
//  SearchEntity.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/19.
//

import Foundation

struct SearchEntity: Codable {
    let _id: String
    let name: String
    let isDiet: Bool
    let isCategory: Bool
    let distance: Double?
    let longitude: Double
    let latitude: Double
    
    func toDomain() -> SearchDataModel {
        return SearchDataModel.init(id: _id,
                                    title: name,
                                    isDiet: isDiet,
                                    isCategory: isCategory,
                                    distance: distance,
                                    latitude: latitude,
                                    longitude: longitude)
    }
}
