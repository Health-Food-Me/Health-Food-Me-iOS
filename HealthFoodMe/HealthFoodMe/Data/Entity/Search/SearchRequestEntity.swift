//
//  SearchRequestEntity.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/19.
//

import Foundation

struct SearchRequestEntity: Codable {
    let longtitude: Double
    let latitude: Double
    let keyword: String
}
