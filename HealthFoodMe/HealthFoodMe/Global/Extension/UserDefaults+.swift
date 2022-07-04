//
//  UserDefaults+.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

extension UserDefaults {
    
    /// UserDefaults key value가 많아지면 관리하기 어려워지므로 enum 'Keys'로 묶어 관리합니다.
    enum Keys {
        /// String
        static var Email = "Email"
        
        /// String
        static var PW = "PW"
    }
}
