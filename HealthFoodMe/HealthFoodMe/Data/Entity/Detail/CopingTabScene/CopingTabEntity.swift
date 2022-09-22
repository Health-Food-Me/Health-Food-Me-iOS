//
//  CopingTabEntity.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/18.
//

import Foundation

// MARK: - DataClass

struct CopingTabEntity: Codable {
    let category: String
    let prescription: CopingDataModel
}

// MARK: - Content

struct CopingDataModel: Codable {
    let recommend, tip: [String]
}
 
