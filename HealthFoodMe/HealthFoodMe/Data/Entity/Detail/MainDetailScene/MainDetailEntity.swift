//
//  MainDetailEntity.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import Foundation

// MARK: - MainDetailEntity
struct MainDetailEntity: Codable {
    let restaurant: Restaurant
    let menu: [Menu]
}

// MARK: - Menu
struct Menu: Codable {
    let id, name: String
    let image: String?
    let kcal, per: Int?
    let price: Int
    let isPick: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image, kcal, per, price, isPick
    }
    
    func toDomain() -> MenuDataModel {
        var imageURL: String?
        if image == "" {
            imageURL = nil
        } else {
            imageURL = image
        }
        return MenuDataModel.init(restaurantID: id, isPick: isPick, memuImageURL: imageURL, menuName: name, menuPrice: price, menuKcal: kcal, carbohydrates: nil, protein: nil, fat: nil)
    }
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: String
    let distance: Int
    let name, logo, category: String
    let hashtag: [String]
    let address: String
    let workTime: [String]
    let contact: String
    let isScrap: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case distance, name, logo, category, hashtag, address, workTime, contact, isScrap
    }
    
    private func getDay(index: Int) -> String {
        switch index {
        case 0: return "월요일"
        case 1: return "화요일"
        case 2: return "수요일"
        case 3: return "목요일"
        case 4: return "금요일"
        case 5: return "토요일"
        default: return "일요일"
        }
    }
    
    func toDomain() -> MainDetailExpandableModel {
        if workTime.count <= 1,
           let string = workTime.first {
            return MainDetailExpandableModel.init(location: address, telephone: contact,labelText: [string], isExpandable: false)
        } else {
            var dayText = [String]()
            
            for (i, worktime) in workTime.enumerated() {
                dayText.append(self.getDay(index: i) + " \(worktime)")
            }
            
            return MainDetailExpandableModel.init(location: address, telephone: contact, labelText: dayText, isExpandable: true)
        }
    }
}
