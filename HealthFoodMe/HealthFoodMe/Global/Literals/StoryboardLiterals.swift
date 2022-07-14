//
//  StoryboardLiterals.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

/**
 
 - Description:
 enum형태로 Storybaords 값을 안전하게 가져오기 위해 사용합니다.
 스토리보드를 추가할때마다 case 과 값을 추가하면 됩니다!
 - UIStoryboard.list(.base)와 같이 사용
 */

enum Storyboards: String {
    case mainMap = "MainMap"
    case mainDetail = "MainDetail"
    case search = "Search"
    case searchResult = "SearchResult"

    case menuTab = "MenuTab"
    case reviewWrite = "ReviewWrite"
    case socialLogin = "SocialLogin"
    case hamburgerBar = "HamburgerBar"
    case blogReviewTab = "BlogReviewTab"
}

extension UIStoryboard {
    static func list(_ name: Storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
}
