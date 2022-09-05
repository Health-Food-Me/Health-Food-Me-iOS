//
//  HelfmeLoginAlertVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/09/06.
//

import UIKit

class HelfmeLoginAlertVC: UIViewController {
    
    // MARK: - Properties
    
    let width = UIScreen.main.bounds.width
    let loginButtonWidth = UIScreen.main.bounds.width - 127
    let deleteButtonWidth = UIScreen.main.bounds.width - 347
    
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
    
    private let alertDeleteBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.Common.alertDeleteBtn, for: .normal)
        return button
    }()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
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
                                   alertDeleteBtn)
        
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
        
        alertDeleteBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.width.height.equalTo(28)
        }

    }
}
