//
//  dayNumberOfWeek.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/08/29.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
