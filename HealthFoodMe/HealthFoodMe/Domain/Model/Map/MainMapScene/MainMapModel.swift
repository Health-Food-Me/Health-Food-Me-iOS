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
  let type: PointerType
}

enum PointerType {
  case normalFood
  case healthFood
}

struct MainMapCategory {
    let menuName: String
    let menuIcon: UIImage
    
    static let categorySample: [MainMapCategory] = [MainMapCategory(menuName: "샐러드", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "포케", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "샌드위치", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "샤브샤브", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "보쌈", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "고깃집", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "덮밥", menuIcon: ImageLiterals.Map.scrapIcon!), MainMapCategory(menuName: "키토김밥", menuIcon: ImageLiterals.Map.scrapIcon!)]
}
