//
//  UIViewController+.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

extension UIViewController {
    
    /**
     - Description: 화면 터치시 작성 종료
     */
    /// 화면 터치시 작성 종료하는 메서드
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     - Description: 화면 터치시 키보드 내리는 Extension
     */
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func makeAlert(alertType: AlertType = .logoutAlert,
                   title: String?,
                   subtitle: String?,
                   okAction: (() -> Void)?) {
        
        let alertVC = ModuleFactory.resolve().makeHelfmeAlertVC(type: alertType)
        
        alertVC.alertType = alertType
        if let title = title {
            alertVC.alertTitle = title
        }
        if let subtitle = subtitle {
            alertVC.alertContent = subtitle
        }
        alertVC.okAction = okAction
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true)
    }
    
    func makeAlert(alertType: AlertType = .logoutAlert,
                   title: String?,
                   subtitle: String?,
                   okAction: (() -> Void)?,
                   closeAction: (()->Void)?) {
        
        let alertVC = ModuleFactory.resolve().makeHelfmeAlertVC(type: alertType)
        
        alertVC.alertType = alertType
        if let title = title {
            alertVC.alertTitle = title
        }
        if let subtitle = subtitle {
            alertVC.alertContent = subtitle
        }
        alertVC.okAction = okAction
        alertVC.closeAction = closeAction
        
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true)
    }
}
