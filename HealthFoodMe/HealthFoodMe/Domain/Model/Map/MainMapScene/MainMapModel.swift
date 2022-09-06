//
//  MainMapModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

struct MapPointDataModel {
  let latitude: Double
  let longtitude: Double
  let restaurantName: String?
  let type: PointerType
}

enum PointerType {
  case normalFood
  case healthFood
}

struct MainMapCategory {
    let menuName: String
    let menuIcon: UIImage
    let isDietMenu: Bool
    
    static let categorySample: [MainMapCategory] = [MainMapCategory(menuName: "샐러드", menuIcon: ImageLiterals.Map.saladIcon!, isDietMenu: true), MainMapCategory(menuName: "포케", menuIcon: ImageLiterals.Map.pokeIcon!, isDietMenu: true), MainMapCategory(menuName: "샌드위치", menuIcon: ImageLiterals.Map.sandwichIcon!, isDietMenu: true), MainMapCategory(menuName: "키토김밥", menuIcon: ImageLiterals.Map.kimbapIcon!, isDietMenu: true), MainMapCategory(menuName: "도시락", menuIcon: ImageLiterals.Map.dosirakIcon!, isDietMenu: true),  MainMapCategory(menuName: "샤브샤브", menuIcon: ImageLiterals.Map.shabushabuIcon!, isDietMenu: false), MainMapCategory(menuName: "보쌈", menuIcon: ImageLiterals.Map.bossamIcon!, isDietMenu: false), MainMapCategory(menuName: "스테이크", menuIcon: ImageLiterals.Map.steakIcon!, isDietMenu: false), MainMapCategory(menuName: "덮밥", menuIcon: ImageLiterals.Map.dupbapIcon!, isDietMenu: false), MainMapCategory(menuName: "고깃집", menuIcon: ImageLiterals.Map.meatIcon!, isDietMenu: false)]
}

struct Location {
    let latitude: Double
    let longitude: Double
}
