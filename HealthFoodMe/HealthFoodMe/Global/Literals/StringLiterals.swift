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
            static let reviewWriteCTATitle = "리뷰 쓰기"
        }
        
        struct Menu {
            static let segmentTitle = ["메뉴", "영양정보"]
            static let kcalUnit = "kcal"
            static let gUnit = "(-g당)"
            static let standard = "1인분 (50g)"
            static let carbohydrate = "탄수화물"
            static let protein = "단백질"
            static let fats = "지방"
        }
        
        struct Review {
            static let emptyViewMessage =
        """
        아직 작성된 리뷰가 없습니다
        첫 리뷰를 작성해 주세요
        """
            static let questionTaste = "맛은 어때요?"
            static let questionTasteSub = "필수 한 개 선택해주세요!"
            static let tagGood = "# 맛 최고"
            static let tagSoso = "# 맛 그럭저럭"
            static let tagBad = "# 맛 별로에요"
            static let questionFeeling = "어떤 점이 좋았나요?"
            static let questionFeelingSub = "식당을 방문하신 후 좋았던 부분에 체크해주세요! (중복가능)"
            static let tagNoBurden = "# 약속 시 부담 없는"
            static let tagEasy = "# 양 조절 쉬운"
            static let tagStrong = "# 든든한"
            static let questionReview = "후기를 남겨주세요."
            static let questionReviewSub = "식당 이용 후기, 메뉴추천, 꿀팁 등 자유롭게 작성해주세요!"
            static let reviewPlaceholder = "리뷰를 작성해주세요 (최대 500자)"
            static let reviewTextCount = "0/500자"
            static let questionPhoto = "사진을 올려주세요"
            static let questionPhotoOption = "(선택)"
            static let questionPhotoSub =  "해당 가게와 무관한 사진을 첨부하면 노출 제한 처리될 수 있습니다. \n사진첨부 시 개인정보가 노출되지 않도록 유의해주세요."
            static let writeReview = "리뷰 쓰기"
            static let checkReviewToast = "별점과 맛 평가는 필수입니다."
            static let checkPhotoToast = "사진 첨부는 최대 3장까지만 가능합니다!"
            
            static let gotoRestaurant = "식당 보러 가기"
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
            static let searchBar = "식당 검색"
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
            
            static let reportStoreTitle = "가게 제보하기"
            static let reportStoreContent = "제보할 가게를 적어주세요."
            static let reportEditTitle = "수정 사항 제보"
            static let reportEditContent = "문의할 내용을 입력해주세요."
            
            static let hello = "안녕하세요!"
            static let todayHelfume = "오늘도 헬푸미하세요"
        }
    }
    
    struct Search {
        static let search = "식당 검색"
        static let searchRecent = "최근 검색어"
        static let searchMap = "지도 보기"
        static let searchList = "목록 보기"
        static let searchEmpty = "해당되는 검색 결과가 없습니다"
        static let searchAnother = "다른 식당 또는 음식명을 입력해주세요!"
    }
    
    struct Scrap {
        static let scrapTitle = "스크랩한 식당"
        static let withHelfme = "헬푸미와 외식 걱정을 날려보세요!"
        static let dietStore = "다이어터도 즐길 수 있는 식당"
        static let goScrap = "스크랩하러 가기"
    }
  
    struct Setting {
        static let customerServiceTitle = "고객지원"
        static let askButtonTitle = "문의하기"
        static let userWithdrawalTitle = "회원탈퇴"
        static let termsTitle = "약관 및 정책"
        static let openSourceButtonTitle = "오픈 소스 정보"
        static let naverMapTerms = "네이버 지도 법적 공지"
        static let naverMapLicense = "네이버 지도 오픈 소스 라이선스"
    }
    
    struct Coping {
        static let recommendHeader = "추천하는 이유!"
        static let eatingHeader = "이렇게 드셔보세요!"
        static let copingEmpty = "해당되는 카테고리에\n 관련된 외식대처법은 준비중입니다"
        static let copingWait = "조금만 기다려 주세요!"
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
