//
//  MainMapModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import Foundation

struct MapPointDataModel {
  let latitude: Double
  let longtitude: Double
  let type: PointerType
}

enum PointerType {
  case normalFood
  case healthFood
}
