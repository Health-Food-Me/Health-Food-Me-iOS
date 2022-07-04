//
//  BaseNotiList.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/16.
//

import UIKit

enum BaseNotiList : String{
  case moveHomeTab
  
  static func makeNotiName(list : BaseNotiList) -> NSNotification.Name{
    return Notification.Name(String(describing: list))
  }
  
}

extension BaseVC{
//  func addObservers(){
//    addObserverAction(.showIndicator) { _ in
//      let indicatorVC = self.factory.instantiateIndicatorVC()
//      self.present(indicatorVC, animated: true, completion: nil)
//    }
//
//    addObserverAction(.hideIndicator) { _ in
//      self.postObserverAction(.indicatorComplete, object: nil)
//    }
//
//    addObserverAction(.showNetworkError) { _ in
//      self.makeAlert(alertCase: .simpleAlert, title: I18N.Alert.error, content: I18N.Alert.networkError)
//    }
//
//    addObserverAction(.moveHomeToPlanList) { noti in
//      if let viewCase = noti.object as? TravelSpotDetailType{
//        guard let spotlistVC = UIStoryboard.list(.travelSpot).instantiateViewController(withIdentifier: TravelSpotDetailVC.className) as? TravelSpotDetailVC else {return}
//        spotlistVC.type = viewCase
//        self.navigationController?.pushViewController(spotlistVC, animated: true)
//      }
//    }
//
//    addObserverAction(.moveHomeTab) { _ in
//      self.tabClicked(index: .home)
//    }
//
//    NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
//                                           object: nil,
//                                           queue: nil) { _ in
//      AppLog.log(at: FirebaseAnalyticsProvider.self, .enterBackGround)
//    }
//
//    NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
//                                           object: nil,
//                                           queue: nil) { _ in
//      AppLog.log(at: FirebaseAnalyticsProvider.self, .enterForeGround)
//    }
//
//  }
  
}

