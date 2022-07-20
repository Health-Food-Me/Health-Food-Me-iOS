//
//  HamburgerBarVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/10.
//

import UIKit

import SnapKit
import MessageUI

enum HamburgerType {
    case editName
    case scrap
    case myReview
    case setting
}

protocol HamburgerbarVCDelegate: AnyObject {
    func HamburgerbarVCDidTap(hamburgerType: HamburgerType)
}

class HamburgerBarVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: HamburgerbarVCDelegate?
    var hambergurBarViewTranslation = CGPoint(x: 0, y: 0)
    var hambergurBarViewVelocity = CGPoint(x: 0, y: 0)
    var name: String? = "배부른 현우는 행복해요"
    private let screenWidth = UIScreen.main.bounds.width
    private var menuButtons: [UIButton] = []
    private let buttonTitles: [String] = ["스크랩한 식당", "내가 쓴 리뷰", "가게 제보하기",
                                          "수정사항 제보하기"]
    private var dividingLineViews: [UIView] = []
    
    private let hamburgerBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        
        return view
    }()

    private var hellowStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 3
        st.distribution = .equalSpacing
        st.alignment = .leading
        return st
    }()
    
    private var nickNameStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 2
        st.distribution = .equalSpacing
        st.alignment = .center
        return st
    }()
    
    private lazy var helloLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Map.HamburgerBar.hello
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoRegular(size: 18)
        
        return lb
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let lb = UILabel()
        if let name = name {
            lb.text = "\(name)님"
        }
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoRegular(size: 18)
        
        var text = name ?? ""
        print(text)
        lb.partFontChange(targetString: text, font: .NotoMedium(size: 18))
        
        return lb
    }()
    
    private lazy var todayHelfmeLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Map.HamburgerBar.todayHelfume
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoRegular(size: 18)
        
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
        st.spacing = 19
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
        addButtonAction()
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
        setHellowStackView()
        self.view.backgroundColor = .clear
    }
    
    private func setButtons() {
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
    
    private func setHellowStackView() {
        nickNameStackView.addArrangedSubviews(nickNameLabel, editNameButton)
        hellowStackView.addArrangedSubviews(helloLabel, nickNameStackView, todayHelfmeLabel)
    }

    private func setLayout() {
        view.addSubviews(hamburgerBarView)
        
        hamburgerBarView.addSubviews(hellowStackView,
                                     storeButtonStackView, reportButtonStackView,
                                     settingButton, logoutButton, dividingLineViews[0],
                                     dividingLineViews[1], dividingLineViews[2])
        
        hamburgerBarView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.71)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(screenWidth)
        }
        
        hellowStackView.snp.makeConstraints { make in
            make.top.equalTo(hamburgerBarView).inset(96)
            make.leading.equalTo(hamburgerBarView).inset(20)
        }
        
        dividingLineViews[0].snp.makeConstraints { make in
            make.width.equalTo(hamburgerBarView)
            make.top.equalTo(hellowStackView.snp.bottom).offset(38)
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
        UIView.animate(withDuration: 0.3) {
            self.hamburgerBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.backgroundColor = .helfmeBlack.withAlphaComponent(0.4)
            self.view.layoutIfNeeded()
        }
    }
    
    private func dismissHamburgerBarWithAnimation() {
        
        self.hamburgerBarView.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(screenWidth)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    private func addHamburgerBarGesture() {
        self.hamburgerBarView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveHamburgerBarWithGesture(_:))))
    }
    
    private func addButtonAction() {
        editNameButton.press {
            self.dismiss(animated: false)
            self.delegate?.HamburgerbarVCDidTap(hamburgerType: .editName)
        }
        
        menuButtons[0].press {  
            self.dismiss(animated: false)
            self.delegate?.HamburgerbarVCDidTap(hamburgerType: .scrap)
        }
        
        menuButtons[1].press {
            self.dismiss(animated: false)
            self.delegate?.HamburgerbarVCDidTap(hamburgerType: .myReview)
        }
        
        menuButtons[2].press {
            self.presentReportMail(title: I18N.Map.HamburgerBar.reportStoreTitle, content: I18N.Map.HamburgerBar.reportStoreContent)
        }
        
        menuButtons[3].press {
            self.presentReportMail(title: I18N.Map.HamburgerBar.reportEditTitle, content: I18N.Map.HamburgerBar.reportEditContent)
        }
        
        settingButton.press {
            self.dismiss(animated: false)
            
            self.delegate?.HamburgerbarVCDidTap(hamburgerType: .setting)
        }
        
        logoutButton.press {
            self.makeAlert(alertType: .logoutAlert,
                      title: I18N.HelfmeAlert.logout,
                      subtitle: I18N.HelfmeAlert.logoutContent) {
                self.makeAlert(title: "", message: "로그아웃 성공 ~ ~ !")
            }
        }
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

extension HamburgerBarVC: MFMailComposeViewControllerDelegate {
    private func presentReportMail(title: String, content: String) {
        let mailComposeVC = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["0inn1220@gmail.com"])
            mailComposeVC.setSubject(title)
            mailComposeVC.setMessageBody(content, isHTML: false)
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            makeAlert(title: "메세지 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

