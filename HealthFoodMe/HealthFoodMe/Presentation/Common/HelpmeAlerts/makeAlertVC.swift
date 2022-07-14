//
//  makeAlertVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/15.
//

import UIKit

extension UIViewController {
    func makeAlert(alertType: AlertType = .logoutAlert,
                   title: String?,
                   subtitle: String?,
                   okAction: (() -> Void)? ) {
        
        let alertVC = ModuleFactory.resolve().makeHelfmeAlertVC()
        
        alertVC.alertType = alertType
        alertVC.title = title
        if let subtitle = subtitle {
            alertVC.alertContent = subtitle
        }
        alertVC.okAction = okAction
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true)
    }
}
