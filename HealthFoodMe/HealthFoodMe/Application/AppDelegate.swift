//
//  SceneDelegate.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

import AuthenticationServices
import KakaoSDKCommon
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // 화면 세로방향 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KakaoSDK.initSDK(appKey : IDLiterals.kakaoSDKAPPKey)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "00000.abcabcabcabc.0000(로그인에 사용한 UserIdentifier)") { (credentialState, error) in
            switch credentialState {
            case .authorized: // 이미 증명이 된 경우 (정상)
                print("authorized")
            // The Apple ID credential is valid.
            case .revoked:    // 증명을 취소했을 때,
                print("revoked")
                                // 로그인뷰로 이동하기
            case .notFound:   // 증명이 존재하지 않을 경우
                print("notFound")
                                // 로그인뷰로 이동하기
                
            default:
                break
            }
        }
        
        NMFAuthManager.shared().clientId = IDLiterals.naverMapsClientID
        return true
    }

    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
}

