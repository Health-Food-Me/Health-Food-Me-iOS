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
        static let title = "헬푸미"
        static let subTitle =
"""
샐러드부터 일반식까지
다이어터를 위한 식당 추천 지도앱
"""
    }
    
    struct Detail {
        struct Main {
            static let buttonTitles = ["메뉴", "외식대처법", "리뷰"]
        }
        
        struct Menu {
            static let segmentTitle = ["메뉴", "영양정보"]
            static let kcalUnit = "kcal"
            static let standard = "1인분 (50g)"
            static let carbohydrate = "탄수화물"
            static let protein = "단백질"
            static let fats = "지방"
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
    
    struct Map {
        struct Main {
            static let searchBar = "식당, 음식 검색"
        }
        
        struct HamburgerBar {
            static let logout = "로그아웃"
            static let setting = "설정"
            static let reposrtCorrection = "수정사항 제보하기"
            static let reportStore = "가게 제보하기"
            static let myReview = "내가 쓴 리뷰"
            static let scrapList = "스크랩한 식당"
            static let buttonTitles = ["스크랩한 식당", "내가 쓴 리뷰", "가게 제보하기",
                                       "수정사항 제보하기"]
        }
    }
    
    struct Search {
        static let searchEmpty = "해당되는 검색 결과가 없습니다"
        static let searchAnother = "다른 식당 또는 음식명을 입력해주세요!"
    }
    
    struct Scrap {
        static let scrapTitle = "스크랩한 식당"
        static let withHelfme = "헬푸미와 외식 걱정을 날려보세요!"
        static let dietStore = "다이어터도 즐길 수 있는 식당"
        static let goScrap = "스크랩하러 가기"
    }
}
