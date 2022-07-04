//
//  ImageLiterals.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

struct ImageLiterals {
    
    struct MainTabBar {
        static let homeIcon = UIImage(named: "icn_homeT")
        static let homeIcon_selected = UIImage(named: "icn_home_selected")
        static let townIcon = UIImage(named: "icn_town")
        static let townIcon_selected = UIImage(named: "icn_town_selected")
        static let locationIcon = UIImage(named: "icn_location")
        static let locationIcon_selected = UIImage(named: "icn_location_selected")
        static let chatIcon = UIImage(named: "icn_chat")
        static let chatIcon_selected = UIImage(named: "icn_chat_selected")
        static let profileIcon = UIImage(named: "icn_profile")
        static let profileIcon_selected = UIImage(named: "icn_profile_selected")
    }
    
    struct PostList2 {
        static let searchIcon = UIImage(named: "icn_search")
        static let menuIcon = UIImage(named: "icn_menu")
        static let alarmIcon = UIImage(named: "icn_alarm")
    }
    
    struct PostDetail {
        static let faceIcon = UIImage(named: "icn_face")
        static let heartOffIcon = UIImage(named: "icn_heart_off")
        static let hearOnIcon = UIImage(named: "icn_heart_on")
        static let homeIcon = UIImage(named: "icn_home")
        static let moreIcon = UIImage(named: "icn_more")
        static let arrowIcon = UIImage(named: "icn_arrow")
        
        static let dummy1 = UIImage(named: "postDetail_1")
        static let dummy2 = UIImage(named: "postDetail_2")
        static let dummy3 = UIImage(named: "postDetail_3")
        static let dummy4 = UIImage(named: "postDetail_4")
        static let dummy5 = UIImage(named: "postDetail_5")
        
        static var sample: [UIImage?] =
            [dummy1, dummy2, dummy3, dummy4, dummy5]
    }
    
    struct PostWrite {
        
    }
}
