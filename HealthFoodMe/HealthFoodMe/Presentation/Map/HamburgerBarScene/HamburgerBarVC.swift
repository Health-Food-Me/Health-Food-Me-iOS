//
//  HamburgerBarVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/10.
//

import UIKit

import SnapKit

class HamburgerBarVC: UIViewController {
    
    // MARK: - Properties
    
    var hambergurBarViewTranslation = CGPoint(x: 0, y: 0)
    var hambergurBarViewVelocity = CGPoint(x: 0, y: 0)
    var name: String? = "배부른 현우는 행복해요"
    private let screenWidth = UIScreen.main.bounds.width
    private lazy var hamburgerBarButton = UIButton()
    private var menuButtons: [UIButton] = []
    private let buttonTitles: [String] = ["스크랩한 식당", "내가 쓴 리뷰", "가게 제보하기",
                                          "수정사항 제보하기"]
    private var dividingLineViews: [UIView] = []
    
    private let hamburgerBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        
        return view
    }()

    private lazy var helloLabel: UILabel = {
        let lb = UILabel()
        if let name = name {
            lb.text =
    """
    안녕하세요!
    \(name)님
    오늘도 헬푸미하세요
    """
        }
        lb.textColor = .helfmeBlack
        lb.font = UIFont.PretendardRegular(size: 18)
        lb.numberOfLines = 3
        lb.setLineSpacing(lineSpacing: 3)
        
        return lb
    }()
    
    private lazy var editNameButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.HamburgerBar.editNameBtn, for: .normal)
        
        return button
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Map.HamburgerBar.logout, for: .normal)
        button.setTitleColor(.helfmeGray1, for: .normal)
        button.titleLabel?.font = UIFont.PretendardRegular(size: 12)
        
        return button
    }()
    
    private var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Map.HamburgerBar.setting, for: .normal)
        button.setTitleColor(.helfmeBlack, for: .normal)
        button.titleLabel?.font = UIFont.PretendardRegular(size: 16)
        
        return button
    }()

    private var storeButtonStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 20
        st.distribution = .equalSpacing
        st.alignment = .leading
        
        return st
    }()
    
    private var reportButtonStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 20
        st.distribution = .equalSpacing
        st.alignment = .leading
        
        return st
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addHamburgerBarGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showHamburgerBarWithAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first,
           touch.view != hamburgerBarView {
            dismissHamburgerBarWithAnimation()
        }
    }
}

// MARK: - Extension

extension HamburgerBarVC {
    
    // MARK: - Methods
    
    private func setUI() {
        setButtons()
        setDivindingView()
    }
    
    private func setButtons() {
        hamburgerBarButton.setTitleColor(.helfmeBlack, for: .normal)
        hamburgerBarButton.setTitle("햄버거바", for: .normal)
        hamburgerBarButton.press { self.showHamburgerBarWithAnimation()
        }
        
        for buttonIndex in 0...3 {
            let button = UIButton()
            button.setTitle(buttonTitles[buttonIndex], for: .normal)
            button.setTitleColor(.helfmeBlack, for: .normal)
            button.titleLabel?.font = UIFont.PretendardRegular(size: 16)
            menuButtons.append(button)
            
            if buttonIndex < 2 {
                storeButtonStackView.addArrangedSubviews(menuButtons[buttonIndex])
            } else {
                reportButtonStackView.addArrangedSubviews(menuButtons[buttonIndex])
            }
        }
    }
    
    private func setDivindingView() {
        for _ in 0...2 {
            let view = UIView()
            view.backgroundColor = .helfmeLineGray
            dividingLineViews.append(view)
        }
    }

    private func setLayout() {
        view.addSubviews(hamburgerBarButton, hamburgerBarView
        )
        
        hamburgerBarView.addSubviews(helloLabel,
                                     editNameButton, storeButtonStackView, reportButtonStackView,
                                     settingButton, logoutButton, dividingLineViews[0],
                                     dividingLineViews[1], dividingLineViews[2])
        
        hamburgerBarButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        hamburgerBarView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.71)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(screenWidth)
        }
        
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(hamburgerBarView).inset(96)
            make.leading.equalTo(hamburgerBarView).inset(20)
        }
        
        editNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(helloLabel.snp.centerY)
            make.leading.equalTo(helloLabel.snp.trailing).offset(8)
        }
        
        dividingLineViews[0].snp.makeConstraints { make in
            make.width.equalTo(hamburgerBarView)
            make.top.equalTo(helloLabel.snp.bottom).offset(38)
            make.height.equalTo(1)
            make.leading.equalTo(hamburgerBarView).inset(0)
        }
        
        storeButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(dividingLineViews[0].snp.bottom).offset(28)
            make.leading.equalTo(hamburgerBarView).inset(20)
        }
        
        dividingLineViews[1].snp.makeConstraints { make in
            make.top.equalTo(storeButtonStackView.snp.bottom).offset(28)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
            make.leading.equalTo(hamburgerBarView).inset(0)
        }
        
        reportButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(dividingLineViews[1].snp.bottom).offset(28)
            make.leading.equalTo(hamburgerBarView).inset(20)
        }
        
        dividingLineViews[2].snp.makeConstraints { make in
            make.top.equalTo(reportButtonStackView.snp.bottom).offset(20)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
            make.leading.equalTo(hamburgerBarView).inset(0)
        }

        settingButton.snp.makeConstraints { make in
            make.top.equalTo(dividingLineViews[2].snp.bottom).offset(28)
            make.leading.equalTo(hamburgerBarView).inset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.leading.equalTo(hamburgerBarView).inset(20)
        }
    }
    
    private func showHamburgerBarWithAnimation() {
        let hamburgerViewWidth = screenWidth * 0.71
        self.hamburgerBarView.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(screenWidth - hamburgerViewWidth)
        }
        UIView.animate(withDuration: 0.4) {
            self.hamburgerBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.backgroundColor = .helfmeBlack.withAlphaComponent(0.4)
            self.view.layoutIfNeeded()
        }
    }
    
    private func dismissHamburgerBarWithAnimation() {
        
        self.hamburgerBarView.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(screenWidth)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = .helfmeWhite
            self.view.layoutIfNeeded()
        }
    }
    
    private func addHamburgerBarGesture() {
        self.hamburgerBarView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveHamburgerBarWithGesture(_:))))
    }
    
    // MARK: - @objc Methods
    
    @objc func moveHamburgerBarWithGesture(_ sender: UIPanGestureRecognizer) {
        
        hambergurBarViewTranslation = sender.translation(in: hamburgerBarView)
        hambergurBarViewVelocity = sender.velocity(in: hamburgerBarView)

        switch sender.state {
        case .changed:
            if hambergurBarViewVelocity.x < 0 {
                UIView.animate(withDuration: 0.1) {
                    self.hamburgerBarView.transform = CGAffineTransform(translationX: self.hambergurBarViewTranslation.x, y: 0)
                }
            }
        case .ended:
            if hambergurBarViewTranslation.x > -80 {
                let containerViewWidth = screenWidth * 0.71
                self.hamburgerBarView.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().inset(screenWidth - containerViewWidth)
                }

                UIView.animate(withDuration: 0.4) {
                    self.view.backgroundColor = .helfmeBlack.withAlphaComponent(0.4)
                    self.hamburgerBarView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.view.layoutIfNeeded()
                }
                
                UIView.animate(withDuration: 0.1) {
                    self.hamburgerBarView.transform = .identity
                }
            } else {
                dismissHamburgerBarWithAnimation()
            }
        default:
            break
        }
    }
}
