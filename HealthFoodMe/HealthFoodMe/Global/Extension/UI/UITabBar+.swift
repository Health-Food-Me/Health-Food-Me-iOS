//
//  UITabBar+.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/15.
//

import UIKit

extension UITabBar {
    
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

