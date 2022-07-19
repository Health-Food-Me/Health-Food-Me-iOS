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
    let isDietRestaurant: Bool
    
    func toDomain() -> SearchDataModel {
        return SearchDataModel.init(id: _id,
                                    title: name,
                                    isDiet: isDietRestaurant)
    }
}
