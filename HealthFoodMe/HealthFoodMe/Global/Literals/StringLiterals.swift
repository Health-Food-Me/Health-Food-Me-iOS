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
      
      struct ChangeNickname {
        static let headerTitle = "프로필 편집"
        static let guideText = "변경할 닉네임을 설정해주세요"
        static let conditionText = "* 특수문자, 이모티콘은 사용 불가합니다\n* 띄어쓰기 포함 최대 12글자"
        static let ctaButtonTitle = "수정 완료"
        static let formatErrMessage =  "닉네임 설정 기준에 적합하지 않습니다"
        static let duplicatedErrMessage = "중복된 닉네임입니다"
      }
      
      struct Withdrawal {
        static let headerTitle = "회원탈퇴"
        static let topGuideText = "탈퇴하면 내 앱 모든 데이터가 사라집니다"
        static let bottomGuideText = "서비스를 탈퇴하려면 닉네임을 입력해주세요"
        static let ctaButtonTitle = "확인"
        
      }
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
        static let search = "식당, 음식 검색"
        static let searchRecent = "최근 검색어"
        static let searchMap = "지도 뷰로 보기"
        static let searchEmpty = "해당되는 검색 결과가 없습니다"
        static let searchAnother = "다른 식당 또는 음식명을 입력해주세요!"
    }
    
    struct Scrap {
        static let scrapTitle = "스크랩한 식당"
        static let withHelfme = "헬푸미와 외식 걱정을 날려보세요!"
        static let dietStore = "다이어터도 즐길 수 있는 식당"
        static let goScrap = "스크랩하러 가기"
    }
    
    struct HelfmeAlert {
        static let logout = "정말 로그아웃 하시겠어요?"
        static let logoutContent =
        """
        로그아웃 시 헬푸미의 업데이트 내용을
        보실 수 없습니다.
        """
        static let yes = "네"
        static let no = "아니요"
        
        static let reviewDelete =
        """
        작성한 리뷰를
        삭제하실 건가요?
        """
        
        static let withdrawal = "정말로 탈퇴하실건가요?"
        static let withdrawalContent =
        """
        탈퇴 시 헬푸미의 새로운 정보를
        얻을 수 없습니다.
        """
        static let withdrawalYes = "네 탈퇴할게요"
    }
}
