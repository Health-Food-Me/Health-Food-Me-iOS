//
//  UIFont+.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

extension AppFontName {
    static let pretendardBold = "Pretendard-Bold"
    static let pretendardMedium = "Pretendard-Medium"
    static let pretendardRegular = "Pretendard-Regular"
    
    static let notoBold = "NotoSansCJKkr-Bold"
    static let notoMedium = "NotoSansCJKkr-Medium"
    static let notoRegular = "NotoSansCJKkr-Regular"
}

extension UIFont {
    // MARK: Pretendard Font
    @nonobjc class func PopBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoBold, size: size)!
    }

    @nonobjc class func PretendardBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pretendardBold, size: size)!
    }

    @nonobjc class func PretendardMedium(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pretendardMedium, size: size)!
    }

    @nonobjc class func PretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pretendardRegular, size: size)!
    }

    @nonobjc class func PopExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoMedium, size: size)!
    }

    @nonobjc class func NotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoRegular, size: size)!
    }

    @nonobjc class func NotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoBold, size: size)!
    }
}
