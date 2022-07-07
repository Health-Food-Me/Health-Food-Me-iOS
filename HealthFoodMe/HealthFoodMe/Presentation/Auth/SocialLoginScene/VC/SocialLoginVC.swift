//
//  SocialLoginVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/05.
//

import UIKit

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SnapKit

class SocialLoginVC: UIViewController {

    // MARK: - Properties
    private lazy var titleImageView = UIImageView()
    private lazy var subtitleImageView = UIImageView()
    private lazy var kakaoLoginButton = UIButton()
    private lazy var appleLoginButton = UIButton()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setAddTarget()
    }
    
}

// MARK: - extension
extension SocialLoginVC {
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let _ = error { self.showKakaoLoginFailMessage() } else {
                    if let accessToken = oauthToken?.accessToken {
                        // 엑세스 토큰 받아와서 서버에게 넘겨주는 로직 작성

                        print("TOKEN", accessToken)
                        self.postSocialLoginData(socialToken: accessToken, socialType: "KAKAO")
                    }
                }
            }
        } else { // 웹으로 로그인해도 똑같이 처리되도록
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let _ = error { self.showKakaoLoginFailMessage() } else {
                    if let accessToken = oauthToken?.accessToken {
                        print("TOKEN", accessToken)
                        self.postSocialLoginData(socialToken: accessToken, socialType: "KAKAO")
                    }
                    // 성공해서 성공 VC로 이동
                }
            }
        }
    }
    
    private func showKakaoLoginFailMessage() {
        self.makeAlert(title: I18N.Alert.error, message: I18N.Auth.kakaoLoginError, okAction: nil, completion: nil)
    }
    
    private func postSocialLoginData(socialToken: String, socialType: String) {

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
    
    private func setUI() {
        titleImageView.image = UIImage(named: "authTitle")
        subtitleImageView.image = UIImage(named: "authSubtitle")
        
        kakaoLoginButton.setTitle("카카오톡 아이디로 로그인", for: .normal)
        kakaoLoginButton.setTitleColor(.black, for: .normal)
        
        appleLoginButton.setTitle("애플 아이디로 로그인", for: .normal)
        appleLoginButton.backgroundColor = UIColor.carrotBlack
    }

    private func setLayout() {
        view.addSubviews(titleImageView, subtitleImageView, kakaoLoginButton, appleLoginButton)
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(270)
            make.centerX.equalToSuperview()
        }
        
        subtitleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleImageView.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        kakaoLoginButton.addTarget(self, action: #selector(doKakaoLogin), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(doAppleLogin), for: .touchUpInside)
    }
    
    // MARK: - @objc Methods
    @objc func doKakaoLogin() {
        kakaoLogin()
    }
    
    @objc func doAppleLogin() {
        appleLogin()
    }
}

extension SocialLoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SocialLoginVC: ASAuthorizationControllerDelegate {
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
            
            if let token = tokenString {
                postSocialLoginData(socialToken: token, socialType: "APPLE")
            }
        default:
            // 실패 시 실패VC로 이동
            print("애플아이디 로그인 실패")
        }
    }
}
