//
//  MainDetailModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import Foundation

struct MainDetailModel {
    
}

struct NameLocation {
    let latitude: Double
    let longtitude: Double
    let name: String
}

struct MainDetailExpandableModel {
    let location: String
    let telephone: String
    let labelText: [String]
    let isExpandable: Bool
}
