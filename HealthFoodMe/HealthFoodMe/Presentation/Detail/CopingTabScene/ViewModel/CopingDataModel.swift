//
//  CopingDataModel.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import Foundation

struct CopingDataModel: Codable {
    let categoryID: String
    let recommend: [String]?
    let eating: [String]?
    
}

extension CopingDataModel {
//    static var sampleCopingData = CopingDataModel(categoryID: "1", recommend: ["먹는 속도가 자연스럽게 느려져요", "다양한 채소와 단백질 섭취가 가능해요", "채소, 버섯, 고기, 해산물 충분히 드실 수 있어요"], eating: ["소스 섭취를 최소화 하세요", "떡, 어묵, 만두, 단호박은 투입을 자제하세요", "칼국수와 죽, 볶음밥 주문은 잠시 참아봐요"])
    static var sampleCopingData = CopingDataModel(categoryID: "1", recommend: [], eating: [])
}
