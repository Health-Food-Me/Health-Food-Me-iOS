//
//  setDefaultFonts.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/05/16.
//

import Foundation
import UIKit

struct AppFontName {
    static let pretendardBold = "Pretendard-Bold"
    static let pretendardMedium = "Pretendard-Medium"
    static let pretendardRegular = "Pretendard-Regular"

    static let notoBold = "NotoSansCJKkr-Bold"
    static let notoMedium = "NotoSansCJKkr-Medium"
    static let notoRegular = "NotoSansCJKkr-Regular"
    
    static let GodoB = "GodoB"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
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
    
    @nonobjc class func NotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoMedium, size: size)!
    }

    @nonobjc class func NotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoRegular, size: size)!
    }

    @nonobjc class func NotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.notoBold, size: size)!
    }
    
    @objc class func myRegularSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pretendardRegular, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pretendardBold, size: size)!
    }

    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pretendardMedium, size: size)!
    }
    
    @objc class func GodoB(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.GodoB, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.pretendardRegular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.pretendardBold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.pretendardMedium
                default:
                    fontName = AppFontName.pretendardRegular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            } else {
                self.init(myCoder: aDecoder)
            }
        } else {
            self.init(myCoder: aDecoder)
        }
    }

     class func overrideInitialize() {
        if self == UIFont.self {
           let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
           let mySystemFontMethod = class_getClassMethod(self, #selector(myRegularSystemFont(ofSize:)))
           method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)

           let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
           method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
           let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:)))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
           method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
    }
  }
}
