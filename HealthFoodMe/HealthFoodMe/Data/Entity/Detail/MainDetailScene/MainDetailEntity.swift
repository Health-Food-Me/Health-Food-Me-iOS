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
    let id, name: String?
    let image: String?
    let kcal: Double?
    let per: Int?
    let price: Int?
    let isPick: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image, kcal, per, price, isPick
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        image = (try? container.decode(String.self, forKey: .image)) ?? ""
        kcal = (try? container.decode(Double.self, forKey: .kcal)) ?? 0
        per = (try? container.decode(Int.self, forKey: .per)) ?? 0
        price = (try? container.decode(Int.self, forKey: .price)) ?? 0
        isPick = (try? container.decode(Bool.self, forKey: .isPick)) ?? false
    }
    
    func toDomain() -> MenuDataModel {
        var imageURL: String?
        var perText: String?
        if image == "" {
            imageURL = nil
        } else {
            imageURL = image
        }
        if let per = self.per {
            perText = String(per)
        } else {
            perText = nil
        }
        return MenuDataModel.init(restaurantID: id ?? "",
                                  isPick: isPick ?? false,
                                  memuImageURL: imageURL,
                                  menuName: name ?? "",
                                  menuPrice: price ?? 0,
                                  menuKcal: kcal,
                                  carbohydrates: nil,
                                  protein: nil,
                                  fat: nil,
                                  per: perText)
    }
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: String
    let distance: Int
    let name, logo: String
    let category: [String]
    let address: String
    let workTime: [String]
    let contact: String
    let isScrap: Bool
    let score: Double
    let menuBoard: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case distance, name, logo, category, address, workTime, contact, isScrap, score, menuBoard
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
