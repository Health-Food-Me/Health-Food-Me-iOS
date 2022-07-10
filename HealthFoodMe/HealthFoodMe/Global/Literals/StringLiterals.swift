//
//  StringLiterals.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

struct I18N {
    
    struct TabBar {
        static let home = "홈"
        static let travelSpot = "여행지"
        static let scrap = "스크랩"
        static let myPlan = "마이 플랜"
    }
    
    struct Auth {
      static let kakaoLoginError = "카카오 로그인에 실패하였습니다."
      static let appleLoginError = "애플 로그인에 실패하였습니다."
    }
    
    struct Alert {
        static let alarm = "알림"
        static let error = "오류"
        static let notInstallKakaomap = "네이버맵이 설치되지 않았습니다."
        static let networkError = "네트워크 상태를 확인해주세요"
        static let copyComplete = "📑 주소가 복사되었습니다"
        static let notOpenTravelSpot = "추후 오픈될 예정입니다"
    }
    
    struct PlanPreview {
        struct Recommend {
            static let title = "콘텐츠를 구매하시면 이런 내용을 볼 수 있어요!"
            static let content =
"""
✔️  장소를 핀한 지도
✔️  정류장 형식 일정
✔️  솔직 후기
✔️  가본 사람만 알 수 있는 꿀팁
✔️  다음 장소로 이동할 때의 교통편
"""
        }
    }
    
    struct HamburgerBar {
        static let hello = "안녕하세요!"
        static let sir = "님"
        static let todayHelfme = "오늘도 헬푸미하세요"
        static let scrapList = "스크랩한 식당"
        static let myReview = "내가 쓴 리뷰"
        static let reportStore = "가게 제보하기"
        static let reposrtCorrection = "수정사항 제보하기"
        static let setting = "설정"
        static let logout = "로그아웃"
    }
}
