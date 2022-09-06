//
//  SceneDelegate.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit

import AuthenticationServices
import FirebaseCore
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // 화면 세로방향 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        KakaoSDK.initSDK(appKey : IDLiterals.kakaoSDKAPPKey)
        
        let userManager = UserManager.shared
        if userManager.hasAccessToken {
            switch userManager.isAppleLoginned {
            case true:
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: userManager.appleUserIdentifier ?? "") { (credentialState, error) in
                    switch credentialState {
                    case .authorized: // 이미 증명이 된 경우 (정상)
                        print("authorized")
                        userManager.setLoginStatus(true)
                    case .revoked:    // 증명을 취소했을 때,
                        print("revoked")
                        userManager.setLoginStatus(false)
                    case .notFound:   // 증명이 존재하지 않을 경우
                        print("notFound")
                        userManager.setLoginStatus(false)
                    default:
                        break
                    }
                }
            case false:
                if AuthApi.hasToken() {
                    UserApi.shared.accessTokenInfo { data, error in
                        if let error = error {
                            if let sdkError = error as? SdkError,
                               sdkError.isInvalidTokenError() == true {
                                userManager.setLoginStatus(false)
                            }
                        } else {
                            // 토큰 유효성이 확인된 경우
                            userManager.setLoginStatus(true)
                        }
                    }
                } else {
                    //유효한 토큰이 없는 경우
                    userManager.setLoginStatus(false)
                }
            }
        } else {
            // access token 이 없는 경우.
            userManager.setLoginStatus(false)
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

