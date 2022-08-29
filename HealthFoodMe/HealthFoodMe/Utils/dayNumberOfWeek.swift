//
//  dayNumberOfWeek.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/08/29.
//

import Foundation

extension Date {
    // Swift 상에서는 일 -> 1, 월 -> 2로 표기되지만,
    // 현재 서버에서는 월 -> 0, 화 -> 1로 표기되고 있어서 변환하는 계산식을 추가하였습니다.
    func dayNumberOfWeek() -> Int {
        if let day = Calendar.current.dateComponents([.weekday], from: self).weekday {
            switch(day) {
                case 1      : return 6
                case 2      : return 0
                case 3...7  : return day - 2
                default     : return -1
            }
        } else {
            return -1
        }
    }
}
