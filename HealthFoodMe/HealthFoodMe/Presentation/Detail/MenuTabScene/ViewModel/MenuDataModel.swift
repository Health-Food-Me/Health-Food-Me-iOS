//
//  MenuDataModel.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/06.
//

import Foundation

struct MenuDataModel: Codable {
    let restaurantID: String
    let isPick: Bool
    let memuImageURL: String
    let menuName: String
    let menuPrice: Int
    let menuKcal: Int
    let carbohydrates: Int
    let protein: Int
    let fat: Int
}

extension MenuDataModel {
    static var sampleMenuData: [MenuDataModel] = [
        MenuDataModel(restaurantID: "1", isPick: true, memuImageURL: "", menuName: "리코타치즈샐러디", menuPrice: 6900,
            menuKcal: 297, carbohydrates: 24, protein: 12, fat: 14),
        MenuDataModel(restaurantID: "2", isPick: true, memuImageURL: "", menuName: "콥샐러디", menuPrice: 6300,
            menuKcal: 219, carbohydrates: 34, protein: 13, fat: 15),
        MenuDataModel(restaurantID: "3", isPick: false, memuImageURL: "", menuName: "멕시칸랩", menuPrice: 6300,
            menuKcal: 565, carbohydrates: 44, protein: 14, fat: 34),
        MenuDataModel(restaurantID: "4", isPick: false, memuImageURL: "", menuName: "존맛탱", menuPrice: 6300,
            menuKcal: 565, carbohydrates: 54, protein: 15, fat: 45),
        MenuDataModel(restaurantID: "1", isPick: true, memuImageURL: "", menuName: "리코타치즈샐러디", menuPrice: 6900,
            menuKcal: 297, carbohydrates: 64, protein: 16, fat: 67),
        MenuDataModel(restaurantID: "2", isPick: true, memuImageURL: "", menuName: "콥샐러디", menuPrice: 6300,
            menuKcal: 219, carbohydrates: 74, protein: 17, fat: 56),
        MenuDataModel(restaurantID: "3", isPick: false, memuImageURL: "", menuName: "멕시칸랩", menuPrice: 6300,
            menuKcal: 565, carbohydrates: 84, protein: 18, fat: 45),
        MenuDataModel(restaurantID: "4", isPick: false, memuImageURL: "", menuName: "존맛탱", menuPrice: 6300,
            menuKcal: 565, carbohydrates: 94, protein: 19, fat: 34)
     ]
}
