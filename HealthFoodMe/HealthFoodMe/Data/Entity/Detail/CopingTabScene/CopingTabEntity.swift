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
    let content: Content
}

// MARK: - Content

struct Content: Codable {
    let recommend, tip: [String]
}
 
