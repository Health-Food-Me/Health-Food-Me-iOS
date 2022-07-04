//
//  manageObserverAction.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/05/16.
//

import Foundation

extension NSObject {
  func postObserverAction(_ keyName: BaseNotiList, object: Any? = nil) {
    NotificationCenter.default.post(name: BaseNotiList.makeNotiName(list: keyName), object: object)
  }
  
  func addObserverAction(_ keyName: BaseNotiList, action : @escaping (Notification) -> Void) {
    NotificationCenter.default.addObserver(forName: BaseNotiList.makeNotiName(list: keyName),
                                           object: nil,
                                           queue: nil,
                                           using: action)
  }
  
  func removeObserverAction(_ keyName: BaseNotiList) {
    NotificationCenter.default.removeObserver(self, name: BaseNotiList.makeNotiName(list: keyName), object: nil)
  }
}
