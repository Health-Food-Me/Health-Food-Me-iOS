//
//  CustomTagLabel.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/15.
//

import UIKit

class CustomTagLabel: UILabel {
    
    private let topInset: Int = 4
    private let leftInset: Int =
    private let bottomInset: Int = 10
    private let rightInset: Int = 10
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
