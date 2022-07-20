//
//  SearchRequestEntity.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/19.
//

import Foundation

struct SearchRequestEntity: Codable {
    let longitude: Double
    let latitude: Double
    let keyword: String
}
