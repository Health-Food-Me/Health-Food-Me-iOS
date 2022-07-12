//
//  StringLiterals.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

struct I18N {
    
    struct Auth {
      static let kakaoLoginError = "카카오 로그인에 실패하였습니다."
      static let appleLoginError = "애플 로그인에 실패하였습니다."
    }
    
    struct Detail {
        struct Main {
            static let buttonTitles = ["메뉴", "외식대처법", "리뷰"]
        }
    }
    
    struct Alert {
        static let alarm = "알림"
        static let error = "오류"
        static let notInstallKakaomap = "네이버맵이 설치되지 않았습니다."
        static let networkError = "네트워크 상태를 확인해주세요"
        static let copyComplete = "📑 주소가 복사되었습니다"
        static let notOpenTravelSpot = "추후 오픈될 예정입니다"
    }
    
    struct HamburgerBar {
        static let logout = "로그아웃"
        static let setting = "설정"
        static let reposrtCorrection = "수정사항 제보하기"
        static let reportStore = "가게 제보하기"
        static let myReview = "내가 쓴 리뷰"
        static let scrapList = "스크랩한 식당"
    }
}
