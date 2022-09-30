//
//  HamburgerBarVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/10.
//

import UIKit

import SnapKit
import MessageUI
import KakaoSDKUser

enum HamburgerType {
    case editName
    case scrap
    case myReview
    case setting
}

protocol HamburgerbarVCDelegate: AnyObject {
    func hamburgerbarVCDidTap(hamburgerType: HamburgerType)
}

class HamburgerBarVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: HamburgerbarVCDelegate?
    var hamburgerBarViewTranslation = CGPoint(x: 0, y: 0)
    var hamburgerBarViewVelocity = CGPoint(x: 0, y: 0)
    var name: String? = " "
    private var isBrowsing: Bool {
        return UserManager.shared.isBrowsing
    }
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

    private var helloStackView: UIStackView = {
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
    
    private var nickNameWithButtonStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
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
    
    private lazy var nickNameButton: UIButton = {
        let button = UIButton()
        if let name = name {
            button.setTitle("\(name)", for: .normal)
        }
        button.setTitleColor(.helfmeBlack, for: .normal)
        button.titleLabel?.font = UIFont.NotoMedium(size: 18)
        return button
    }()
    
    private lazy var sirLabel: UILabel = {
        let lb = UILabel()
        lb.text = "님"
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 18)
        return lb
    }()
    
    private lazy var needLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인이 필요해요", for: .normal)
        button.setTitleColor(.helfmeBlack, for: .normal)
        button.titleLabel?.font = UIFont.NotoMedium(size: 18)
        return button
    }()
    
    private lazy var needLoginImageButton: UIButton = {
        let button = UIButton()
        if self.isBrowsing {
            button.setImage(ImageLiterals.HamburgerBar.needLoginBtn, for: .normal)
        } else {
            button.setImage(ImageLiterals.HamburgerBar.editNameBtn, for: .normal)
        }
        
        return button
    }()
    
    private var needLoginStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
        st.distribution = .equalSpacing
        st.alignment = .center
        return st
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
        button.contentHorizontalAlignment = .leading
        
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
    
    
    private lazy var nicknameChangeSuccessView: UpperToastView = {
      let toastView = UpperToastView(title: I18N.Auth.ChangeNickname.nicknameChangeSuccees)
      toastView.layer.cornerRadius = 20
      return toastView
    }()
    

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        addHamburgerBarGesture()
        addButtonAction()
        addObserver()
        fetchUserNickname()
        updateUIWithBrowsingState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        setStackView()
        self.view.backgroundColor = .clear
    }
    
    private func setButtons() {
        for buttonIndex in 0...3 {
            let button = UIButton()
            button.setTitle(buttonTitles[buttonIndex], for: .normal)
            button.setTitleColor(.helfmeBlack, for: .normal)
            button.titleLabel?.font = UIFont.PretendardRegular(size: 16)
            button.contentHorizontalAlignment = .leading
            menuButtons.append(button)
            
            if buttonIndex < 2 {
                storeButtonStackView.addArrangedSubviews(menuButtons[buttonIndex])
            } else {
                reportButtonStackView.addArrangedSubviews(menuButtons[buttonIndex])
            }
            
            menuButtons[buttonIndex].snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.leading.equalToSuperview().inset(0)
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
    
    private func setStackView() {
        nickNameStackView.addArrangedSubviews(nickNameButton, sirLabel)
        needLoginStackView.addArrangedSubviews(needLoginButton, needLoginImageButton)
        nickNameWithButtonStackView.addArrangedSubviews(nickNameStackView, editNameButton)
        helloStackView.addArrangedSubviews(helloLabel, nickNameWithButtonStackView, todayHelfmeLabel)
    }

    private func setLayout() {
        view.addSubviews(hamburgerBarView,nicknameChangeSuccessView)
    
        
        hamburgerBarView.addSubviews(helloStackView,
                                     storeButtonStackView, reportButtonStackView,
                                     settingButton, logoutButton, dividingLineViews[0],
                                     dividingLineViews[1], dividingLineViews[2])
        
        hamburgerBarView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.71)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(screenWidth)
        }
        
        nicknameChangeSuccessView.snp.makeConstraints { make in
          make.width.equalTo(300)
          make.height.equalTo(40)
          make.top.equalTo(-40)
          make.centerX.equalToSuperview()
        }
        
        helloStackView.snp.makeConstraints { make in
            make.top.equalTo(hamburgerBarView).inset(96)
            make.leading.equalTo(hamburgerBarView).inset(20)
            make.trailing.equalTo(hamburgerBarView).inset(10)
        }
        
        dividingLineViews[0].snp.makeConstraints { make in
            make.width.equalTo(hamburgerBarView)
            make.top.equalTo(helloStackView.snp.bottom).offset(38)
            make.height.equalTo(1)
            make.leading.equalTo(hamburgerBarView).inset(0)
        }
        
        storeButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(dividingLineViews[0].snp.bottom).offset(28)
            make.leading.trailing.equalTo(hamburgerBarView).inset(20)
        }
        
        dividingLineViews[1].snp.makeConstraints { make in
            make.top.equalTo(storeButtonStackView.snp.bottom).offset(28)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
            make.leading.equalTo(hamburgerBarView).inset(0)
        }
        
        reportButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(dividingLineViews[1].snp.bottom).offset(28)
            make.leading.trailing.equalTo(hamburgerBarView).inset(20)
        }
        
        dividingLineViews[2].snp.makeConstraints { make in
            make.top.equalTo(reportButtonStackView.snp.bottom).offset(20)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
            make.leading.equalTo(hamburgerBarView).inset(0)
        }

        settingButton.snp.makeConstraints { make in
            make.top.equalTo(dividingLineViews[2].snp.bottom).offset(28)
            make.leading.trailing.equalTo(hamburgerBarView).inset(20)
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
    
    private func fetchUserNickname() {
        guard let userID = UserManager.shared.getUserId else { return }
        UserService.shared.getUserNickname(userId: userID) { result in
            switch(result) {
                case .success(let result):
                    guard let result = result as? UserEntity else { return }
                self.nickNameButton.setTitle(result.name, for: .normal)
            default : self.nickNameButton.setTitle("헬푸미", for: .normal)
            }
        }
    }
    
    private func addObserver() {
        addObserverAction(.nicknameChanged) { noti in
            if let nickname = noti.object as? String {
                self.nickNameButton.setTitle(nickname, for: .normal)
            }
            self.nicknameChangeSuccess()
        }
    }
    
    private func addButtonAction() {
        editNameButton.press {
            let nicknameVC = ModuleFactory.resolve().makeNicknameChangeVC()
            self.navigationController?.pushViewController(nicknameVC, animated: true)
        }
        
        nickNameButton.press {
            let nicknameVC = ModuleFactory.resolve().makeNicknameChangeVC()
            self.navigationController?.pushViewController(nicknameVC, animated: true)
        }
        
        menuButtons[0].press {
            if self.isBrowsing {
                self.presentSocialLoginAlert()
            } else {
                self.dismiss(animated: false)
                self.postObserverAction(.moveFromHamburgerBar,object: HamburgerType.scrap)
            }
        }
        
        menuButtons[1].press {
            if self.isBrowsing {
                self.presentSocialLoginAlert()
            } else {
                self.dismiss(animated: false)
                self.postObserverAction(.moveFromHamburgerBar,object: HamburgerType.myReview)
            }
        }
        
        menuButtons[2].press {
            self.presentReportMail(title: I18N.Map.HamburgerBar.reportStoreTitle, content: I18N.Map.HamburgerBar.reportStoreContent)
        }
        
        menuButtons[3].press {
            self.presentReportMail(title: I18N.Map.HamburgerBar.reportEditTitle, content: I18N.Map.HamburgerBar.reportEditContent)
        }
        
        settingButton.press {
            self.dismiss(animated: false)
            self.postObserverAction(.moveFromHamburgerBar,object: HamburgerType.setting)
        }
        
        logoutButton.press {
            self.makeAlert(alertType: .logoutAlert,
                      title: I18N.HelfmeAlert.logout,
                      subtitle: I18N.HelfmeAlert.logoutContent) {
                if UserManager.shared.isAppleLoginned {
                    UserManager.shared.clearUserInform()
                    self.pushSocialLoginVC()
                } else {
                    self.logoutWithKakao()
                }
            }
        }
        
        [needLoginButton, needLoginImageButton].forEach {
            $0.press {
                self.presentSocialLoginVC()
            }
        }
    }
    
    private func logoutWithKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("카카오 로그아웃 완료")
                UserManager.shared.clearUserInform()
                self.pushSocialLoginVC()
            }
        }
    }
    
    private func presentSocialLoginVC() {
        let rootViewController = ModuleFactory.resolve().makeLoginVC()
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.isNavigationBarHidden = true
        navigation.modalTransitionStyle = .crossDissolve
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true)
    }
    
    private func pushSocialLoginVC() {
        let loginVC = ModuleFactory.resolve().makeLoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func presentSocialLoginAlert() {
        let alert = ModuleFactory.resolve().makeHelfmeLoginAlertVC()
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        alert.loginSuccessClosure = { loginSuccess in
            if loginSuccess {
                self.updateUIWithBrowsingState()
            }
        }
        self.present(alert, animated: true)
    }
    
    private func updateUIWithBrowsingState() {
        updateHelloStackView()
        logoutButton.isHidden = isBrowsing
    }
    
    private func updateHelloStackView() {
        if isBrowsing {
            helloStackView.subviews.forEach {
                $0.removeFromSuperview()
            }
            helloStackView.addArrangedSubviews(needLoginStackView)
        } else {
            guard helloStackView.subviews.count != 3 else { return }
            nickNameButton.setTitle(UserManager.shared.getUserNickname, for: .normal)
            helloStackView.subviews.forEach {
                $0.removeFromSuperview()
            }
            helloStackView.addArrangedSubviews(helloLabel, nickNameWithButtonStackView, todayHelfmeLabel)
        }
    }
    
    // MARK: - @objc Methods
    
    @objc func moveHamburgerBarWithGesture(_ sender: UIPanGestureRecognizer) {
        
        hamburgerBarViewTranslation = sender.translation(in: hamburgerBarView)
        hamburgerBarViewVelocity = sender.velocity(in: hamburgerBarView)

        switch sender.state {
        case .changed:
            if hamburgerBarViewTranslation.x > 0 {
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.hamburgerBarView.transform = CGAffineTransform(translationX: self.hamburgerBarViewTranslation.x, y: 0)
                }
            }
        case .ended:
            if hamburgerBarViewTranslation.x > -80 {
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
            mailComposeVC.setToRecipients(["hfmlove5252@gmail.com"])
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

extension HamburgerBarVC {
    func nicknameChangeSuccess() {
        showUpperToast()
    }
    
    private func showUpperToast() {
      makeVibrate()
        let topInset = calculateTopInset() * (-1)
        nicknameChangeSuccessView.snp.updateConstraints { make in
        make.top.equalTo(topInset + 12)
     }

      UIView.animate(withDuration: 0.5, delay: 0) {
        self.view.layoutIfNeeded()
      } completion: { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          self.hideUpperToast()
        }
      }
    }

    
    private func hideUpperToast() {
        print("HIDE")
      self.nicknameChangeSuccessView.snp.updateConstraints { make in
        make.top.equalTo(-40)
      }
      
      UIView.animate(withDuration: 0.5, delay: 0) {
        self.view.layoutIfNeeded()
      }
    }
}
