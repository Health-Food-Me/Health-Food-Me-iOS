//
//  ImageLiterals.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

struct ImageLiterals {
    
    struct MainDetail {
        static let starIcon = UIImage(named: "icn_star")
        static let starIcon_filled = UIImage(named: "icn_star_filled")
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
