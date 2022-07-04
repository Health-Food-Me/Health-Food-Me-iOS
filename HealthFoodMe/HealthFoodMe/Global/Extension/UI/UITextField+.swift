//
//  UITextField+.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

extension UITextField {
     func setLeftPadding(amount: CGFloat) {
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
         self.leftView = paddingView
         self.leftViewMode = .always
     }
     func setRightPadding(amount: CGFloat) {
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
         self.rightView = paddingView
         self.rightViewMode = .always
     }
    
    /// UITextField의 상태를 리턴함
    var isEmpty: Bool {
        if text?.isEmpty ?? true {
            return true
        }
        return false
    }
    
    /// 자간 설정 메서드
    func setCharacterSpacing(_ spacing: CGFloat) {
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
     }
 }
