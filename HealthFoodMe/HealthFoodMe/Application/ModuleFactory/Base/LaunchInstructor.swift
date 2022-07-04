//
//  LaunchInstructor.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
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
