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
