//
//  MainMapEntity.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import Foundation

struct MainMapEntity: Codable {
    let id, name: String
    let longitude, latitude: Double
    let isDietRestaurant: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, longitude, latitude, isDietRestaurant
    }
    
    func toDomain() -> MapPointDataModel {
        var pointerType: PointerType
        if isDietRestaurant {
            pointerType = .healthFood
        } else {
            pointerType = .normalFood
        }
        return MapPointDataModel.init(latitude: latitude, longtitude: longitude, type: pointerType)
    }
}
