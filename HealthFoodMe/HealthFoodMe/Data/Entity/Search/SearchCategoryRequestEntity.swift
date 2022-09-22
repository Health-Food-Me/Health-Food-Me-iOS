//
//  SearchCategoryEntity.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/09/20.
//

import Foundation

struct SearchCategoryRequestEntity: Codable {
    let longitude: Double
    let latitude: Double
    let category: String
}
