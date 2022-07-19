//
//  FirebaseAnalyticsProvider.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/18.
//

import FirebaseCore
import FirebaseAnalytics

open class FirebaseAnalyticsProvider: RuntimeProviderType {
    public let className: String = "FIRAnalytics"
    public let selectorName: String = "logEventWithName:parameters:"
    
    public init() {}
}
