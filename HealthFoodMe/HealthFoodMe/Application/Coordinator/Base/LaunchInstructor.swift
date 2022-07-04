//
//  LaunchInstructor.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/16.
//

import Foundation

enum LaunchInstructor {
  case signing
  case main
  
  static func configure(_ isAuthorized: Bool = false) -> LaunchInstructor {
    switch isAuthorized {
      case false: return .signing
      case true: return .main
    }
  }
}
