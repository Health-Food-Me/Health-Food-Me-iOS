//
//  URLSchemeManager.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/13.
//

import UIKit

final class URLSchemeManager: NSObject {
    
    // MARK: Properties
    
    static let shared = URLSchemeManager()
    
    // MARK: Life Cycle
    
    private override init() {}
    
    func loadTelephoneApp(phoneNumber: String) {
        let number: String = phoneNumber.trimmingCharacters(in: ["-"])
        if let url = NSURL(string: "tel://" + "\(number)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func loadNaverMapApp(myLocation: NameLocation, destination: NameLocation) {
        if let url = URL.decodeURL(urlString: "nmap://route/public"
                           + "?slat=\(myLocation.latitude)"
                           + "&slng=\(myLocation.longtitude)"
                           + "&sname=\(myLocation.name)"
                           + "&dlat=\(destination.latitude)"
                           + "&dlng=\(destination.longtitude)"
                           + "&dname=\(destination.name)"
                                   + "&appname=\(String(describing: Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String))"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
            UIApplication.shared.open(appStoreURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    func loadKakaoMapApp(myLocation: NameLocation, destination: NameLocation) {
        if let url = URL.decodeURL(urlString: "kakaomap://route" + "?sp=\(myLocation.latitude),\(myLocation.longtitude)" + "&ep=\(destination.latitude),\(destination.longtitude)" + "&by=PUBLICTRANSIT"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            let appStoreURL = URL(string: "http://itunes.apple.com/us/app/id304608425")!
            UIApplication.shared.open(appStoreURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    func loadSafariApp(blogLink: String) {
        let blogURL: String = blogLink
        if let url = NSURL(string: "\(blogURL)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func loadAppleMapApp(location: Location) {
        if let url = NSURL(string: "http://maps.apple.com/?ll=\(location.latitude),\(location.longitude)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

enum NaverTerms: String{
    case serviceTerm = "policy.naver.com/rules/service_pre_20140317.html"
    case naverMapTerm = "policy.naver.com/rules/service_location.html"
    case naverMapOpensource = "policy.naver.com/rules/service_group.html"
}
