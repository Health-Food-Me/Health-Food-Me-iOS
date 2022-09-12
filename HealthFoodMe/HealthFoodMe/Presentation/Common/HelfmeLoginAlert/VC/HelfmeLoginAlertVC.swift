//
//  HelfmeLoginAlertVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/09/06.
//

import UIKit

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class HelfmeLoginAlertVC: UIViewController {
    
    // MARK: - Properties
    
    var loginSuccessClosure: ((Bool)->Void)?
    let width = UIScreen.main.bounds.width
    let loginButtonWidth = UIScreen.main.bounds.width - 127
    let deleteButtonWidth = UIScreen.main.bounds.width - 347
    private let userManager = UserManager.shared
    private var social = ""
    private var accessToken = ""
    
    //MARK: - UI Components
    
    private let loginAlertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    private let alertMessage: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Alert.alertLoginMessage
        lb.font = .NotoMedium(size: 16)
        lb.numberOfLines = 2
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(ImageLiterals.Common.kakaoLoginBtn, for: .normal)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.Common.appleLoginBtn, for: .normal)
        return button
    }()
    
    private let alertDeleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.Common.alertDeleteBtn, for: .normal)
        return button
    }()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTargets()
    }
}

// MARK: - Extension

extension HelfmeLoginAlertVC {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func setLayout() {
        view.addSubviews(loginAlertView)
        loginAlertView.addSubviews(alertMessage,
                                   kakaoLoginButton,
                                   appleLoginButton,
                                   alertDeleteButton)
        
        loginAlertView.snp.makeConstraints {
            let logoutWidth = width * (288/375)
            $0.center.equalToSuperview()
            $0.width.equalTo(logoutWidth)
            $0.height.equalTo(logoutWidth * (219/288))
        }
        
        alertMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(alertMessage.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(loginButtonWidth * 42/248)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(loginButtonWidth * 42/248)
        }
        
        alertDeleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.width.height.equalTo(28)
        }
    }
    
    private func setAddTargets() {
        alertDeleteButton.addTarget(self, action: #selector(alertDeleteButtonTapped), for: .touchUpInside)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if error != nil { self.showKakaoLoginFailMessage() } else {
                    if let accessToken = oauthToken?.accessToken {
                        // 엑세스 토큰 받아와서 서버에게 넘겨주는 로직 작성
                        self.accessToken = accessToken
                        self.social = "kakao"
                        print("TOKEN", accessToken)
                        
                        self.getUserId()
                    }
                }
            }
        } else { // 웹으로 로그인해도 똑같이 처리되도록
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if error != nil { self.showKakaoLoginFailMessage() } else {
                    if let accessToken = oauthToken?.accessToken {
                        self.accessToken = accessToken
                        self.social = "kakao"
                        print("TOKEN", accessToken)
                        
                        self.getUserId()
                    }
                }
            }
        }
    }
    
    private func getUserId() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                if let userID = user?.id {
                    self.userManager.setSocialType(isAppleLogin: false)
                    self.postSocialLoginData()
                }
            }
        }
    }
    
    private func showKakaoLoginFailMessage() {
        self.makeAlert(title: I18N.Alert.error, message: I18N.Auth.kakaoLoginError, okAction: nil, completion: nil)
    }
    
    private func postSocialLoginData() {
        AuthService.shared.requestAuth(social: social,
                                       token: accessToken) { networkResult in
            switch networkResult {
            case .success(let data):
                self.userManager.setSocialToken(token: self.accessToken)
                if let data = data as? SocialLoginEntity {
                    self.userManager.updateHelfmeToken(data.accessToken, data.refreshToken)
                    self.userManager.setCurrentUserWithId(data.user)
                    self.userManager.setLoginStatus(true)
                    self.userManager.setBrowsingState(false)
                    self.dismiss(animated: true) {
                        self.loginSuccessClosure?(true)
                    }
                }
            case .requestErr(let message):
                print("SocialLogin - requestErr: \(message)")
            case .pathErr:
                print("SocialLogin - pathErr")
            case .serverErr:
                print("SocialLogin - serverErr")
            case .networkFail:
                print("SocialLogin - networkFail")
            }
        }
    }
    
    private func appleLogin() {
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    @objc
    private func alertDeleteButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func kakaoLoginButtonTapped() {
        kakaoLogin()
    }
    
    @objc
    private func appleLoginButtonTapped() {
        appleLogin()
    }
}

extension HelfmeLoginAlertVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension HelfmeLoginAlertVC: ASAuthorizationControllerDelegate {
    // Apple ID 연동 성공시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential :
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            let identityToken = appleIDCredential.identityToken
            let tokenString = String(data: identityToken!, encoding: .utf8)
            
            userManager.setSocialType(isAppleLogin: true)
            userManager.setUserIdForApple(userId: userIdentifier)
            
            if let token = tokenString {
                self.accessToken = token
                self.social = "apple"
                postSocialLoginData()
            }
            
        default:
            // 실패 시 실패VC로 이동
            print("애플아이디 로그인 실패")
        }
    }
}
