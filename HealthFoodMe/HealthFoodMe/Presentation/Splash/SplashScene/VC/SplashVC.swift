//
//  SplashVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/17.
//

import UIKit

import Lottie
import FirebaseRemoteConfig

class SplashVC: UIViewController {
    
    // MARK: - Properties
    
    let userManager = UserManager.shared
    lazy var remoteConfig = {
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        config.configSettings = settings
        config.setDefaults(fromPlist: "remote_config_defaults")
        return config
    }()
    private var latestAppVersion: String?
    
    // MARK: - UI Components
    
    private let animationView: AnimationView = .init(name: "splash_iOS")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        playAnimation()
        checkLoginStatusAndPresentVC()
    }
}

// MARK: - Methods

extension SplashVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubview(animationView)
        
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
    }
    
    private func playAnimation() {
        animationView.play()
    }
    
    private func presentMainMapVC() {
        let nav = ModuleFactory.resolve().makeMainMapNavigationController()
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
    
    private func presentSocialLoginVC() {
        let vc = ModuleFactory.resolve().makeLoginVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    private func checkLoginStatusAndPresentVC() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
            UIView.animate(withDuration: 1) {
                self.animationView.alpha = 0
            } completion: { _ in
                self.fetchNeedsUpdate()
            }
        }
    }
    
    private func fetchNeedsUpdate() {
        self.remoteConfig.fetchAndActivate { (status, error) -> Void in
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                let needUpdate = self.remoteConfig.configValue(forKey: "forceUpdate").boolValue
                guard let appVersion = Bundle.appVersion,
                      let versionStandard = self.remoteConfig.configValue(forKey: "versionStandard").stringValue else { return }
                
                self.latestAppVersion = versionStandard
                let versionCompare = appVersion.compare(versionStandard, options: .numeric)
                
                switch (versionCompare, needUpdate) {
                case (.orderedAscending, true):
                    self.showForceUpdateAlert()
                case (.orderedAscending, false):
                    self.showRecommendUpdateAlert()
                default:
                    self.startFlow()
                }
            default:
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    private func showForceUpdateAlert() {
        DispatchQueue.main.async {
            self.makeAlert(title: "최신 버전으로 업데이트 해야합니다",
                           subtitle: "현재 다운로드된 버전이 너무 낮아 앱이 정상 작동하지 않을 수 있습니다.",
                           okAction: {
                URLSchemeManager.shared.loadHelfMeDownload()
            }) {
                self.fetchNeedsUpdate()
            }
        }
    }
    
    private func showRecommendUpdateAlert() {
        DispatchQueue.main.async {
            self.makeAlert(title: "최신 버전으로 업데이트 하시겠습니까?",
                           subtitle: "최신 버전(\(self.latestAppVersion ?? ""))에서 최적의 사용 환경을 보장할 수 있습니다.",
                           okAction: {
                URLSchemeManager.shared.loadHelfMeDownload()
            }) {
                self.startFlow()
            }
        }
    }
    
    private func startFlow() {
        if self.userManager.isLogin == true {
            self.reissuanceToken()
        } else {
            self.presentSocialLoginVC()
        }
    }
}

// MARK: - Network

extension SplashVC {
    // 토큰 재발급에 성공하면 메인으로, 실패하면 소셜로그인으로
    private func reissuanceToken() {
        userManager.reissuanceAccessToken { state in
            if state {
                self.presentMainMapVC()
            } else {
                self.requestSocialLogin()
            }
        }
    }
    
    private func requestSocialLogin() {
        let socialType = userManager.isAppleLoginned ? "apple" : "kakao"
        
        AuthService.shared.requestAuth(social: socialType, token: self.userManager.getSocialToken) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? SocialLoginEntity?,
                   let user = data?.user,
                   let access = data?.accessToken,
                   let refresh = data?.refreshToken {
                    self.userManager.setCurrentUserWithId(user)
                    self.userManager.updateHelfmeToken(access, refresh)
                    self.userManager.setLoginStatus(true)
                    self.presentMainMapVC()
                } else {
                    self.presentSocialLoginVC()
                }
            case .requestErr:
                self.presentSocialLoginVC()
            default:
                self.presentSocialLoginVC()
                print("소셜 토큰 에러")
            }
        }
    }
}
