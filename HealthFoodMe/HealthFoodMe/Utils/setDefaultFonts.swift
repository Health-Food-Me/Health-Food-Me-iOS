//
//  setDefaultFonts.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/05/16.
//

import Foundation
import UIKit

struct AppFontName {
    static let bold = "Poppins-Bold"
    static let regular = "Poppins-Regular"
    static let light = "Poppins-Light"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")

}

extension UIFont {

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.light, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.bold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.light
                default:
                    fontName = AppFontName.regular
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
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
           method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)

           let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
           method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)

           let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:)))
           method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)

           let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:)))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
           method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
    }
  }
}
