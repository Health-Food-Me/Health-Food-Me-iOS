//
//  NSBundle+.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/09/30.
//

import Foundation

public extension Bundle {
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    static var buildVersion: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
