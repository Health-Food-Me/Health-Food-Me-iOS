//
//  SocialLoginVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/05.
//

import UIKit

import SnapKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class SocialLoginVC: UIViewController {

    lazy var titleImageView = UIImageView()
    lazy var subtitleImageView = UIImageView()
    lazy var kakaoLoginButton = UIButton()
    lazy var appleLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
    }
    
    private func setUI() {
        titleImageView.image = UIImage(named: "authTitle")
        subtitleImageView.image = UIImage(named: "authSubtitle")
        
        kakaoLoginButton.setTitle("카카오톡 아이디로 로그인", for: .normal)
        kakaoLoginButton.setTitleColor(.black, for: .normal)
        kakaoLoginButton.backgroundColor = UIColor.yellow
        
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
}

extension SocialLoginVC {
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let _ = error { self.showKakaoLoginFailMessage() }
                else {
                    if let accessToken = oauthToken?.accessToken {
                        //엑세스 토큰 받아와서 서버에게 넘겨주는 로직 작성
                        print("TOKEN", accessToken)
                        self.postSocialLoginData(socialToken: accessToken, socialType: "KAKAO")
                    }
                }
            }
        }
        else { //웹으로 로그인해도 똑같이 처리되도록
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let _ = error { self.showKakaoLoginFailMessage() }
                else {
                    if let accessToken = oauthToken?.accessToken {
                        self.postSocialLoginData(socialToken: accessToken, socialType: "KAKAO")
                    }
                    //성공해서 성공 VC로 이동
                }
            }
        }
    }
    
    func showKakaoLoginFailMessage() {
        self.makeAlert(title: I18N.Alert.error, message: I18N.Auth.kakaoLoginError, okAction: nil, completion: nil)
    }
    
    func postSocialLoginData(socialToken: String, socialType: String) {

    }
}
