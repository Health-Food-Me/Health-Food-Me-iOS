//
//  UserWithdrawlVC.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import UIKit
import RxSwift
import RxCocoa

class UserWithdrawalVC: UIViewController {
  // MARK: - Vars & Lets Part
  private let disposeBag = DisposeBag()
  var viewModel: UserWithdrawalViewModel!
  
  // MARK: - UI Component Part
  
  private var topTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoBold(size: 16)
    label.text = I18N.Auth.Withdrawal.headerTitle
    label.textColor = UIColor.helfmeBlack
    return label
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(ImageLiterals.MainDetail.beforeIcon, for: .normal)
    button.press { self.navigationController?.popViewController(animated: true) }
    return button
  }()
  
  private lazy var headerDividerView: UIView = {
    let dividerView = UIView()
    dividerView.backgroundColor = UIColor.helfmeLineGray
    return dividerView
  }()
  
  private var topGuideLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoRegular(size: 14)
    label.textColor = UIColor.helfmeBlack
    label.text = I18N.Auth.Withdrawal.topGuideText
    return label
  }()
  
  private var bottomGuideLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoRegular(size: 14)
    label.textColor = UIColor.helfmeBlack
    label.text = I18N.Auth.Withdrawal.bottomGuideText
    return label
  }()
  
  private var nicknameTextFieldContainerView: UIView = {
    let view = UIView()
    view.layer.borderColor = UIColor.helfmeLineGray.cgColor
    view.layer.borderWidth = 1
    view.layer.cornerRadius = 8
    return view
  }()
  
  private var nickNameTextField: UITextField = {
    let textField = UITextField()
    textField.textColor = .helfmeBlack
    textField.font = UIFont.NotoMedium(size: 16)
    textField.clearButtonMode = .whileEditing
    return textField
  }()
  
  private var changeCTAButton: CTAButton = {
    let button = CTAButton(enableState: false, title: I18N.Auth.Withdrawal.ctaButtonTitle)
    button.isEnabled = false
    return button
  }()
  
  // MARK: - Life Cycle Part
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bindViewModels()
    self.setLayout()
    self.setUI()
    self.addButtonAction()
    self.addObserver()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    registerForKeyboardNotifications()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    unregisterForKeyboardNotifications()
  }
}

extension UserWithdrawalVC {
  private func setLayout() {
    nicknameTextFieldContainerView.addSubview(nickNameTextField)
    view.addSubviews(topTitleLabel, backButton, headerDividerView,
                    topGuideLabel, bottomGuideLabel,
                     nicknameTextFieldContainerView, changeCTAButton)
    
    nickNameTextField.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    topTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(14)
      make.centerX.equalToSuperview()
      make.height.equalTo(20)
    }
    
    backButton.snp.makeConstraints { make in
      make.height.width.equalTo(24)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
      make.leading.equalToSuperview().offset(20)
    }
    
    headerDividerView.snp.makeConstraints { make in
      make.top.equalTo(topTitleLabel.snp.bottom).offset(13)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    topGuideLabel.snp.makeConstraints { make in
      make.top.equalTo(headerDividerView.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(20)
    }
    
    bottomGuideLabel.snp.makeConstraints { make in
      make.top.equalTo(topGuideLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(20)
    }
    
    nicknameTextFieldContainerView.snp.makeConstraints { make in
      make.top.equalTo(bottomGuideLabel.snp.bottom).offset(16)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(55)
    }
    
    changeCTAButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(44)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
    }
  }
  
  private func setUI() {
    changeCTAButton.layer.cornerRadius = 22
    navigationController?.navigationBar.isHidden = true
  }
  
  private func addButtonAction() {
    changeCTAButton.press {
        let alertVC = ModuleFactory.resolve().makeHelfmeAlertVC(type: .withdrawalAlert)
        alertVC.alertTitle = I18N.Auth.Withdrawal.withdrawlAlertTitle
        alertVC.alertContent = I18N.Auth.Withdrawal.withdrawlContent
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true)
    }
  }
    
    private func addObserver() {
        addObserverAction(.withdrawalButtonClicked) { _ in
            self.deleteUser()
        }
    }
    
    private func deleteUser() {
        guard let userID = UserManager.shared.getUser?.id else { return }
        UserService.shared.deleteUserNickname(userId: userID) { result in
            switch(result) {
                case .success(_) :
                    let loginVC = ModuleFactory.resolve().makeLoginVC()
                    self.navigationController?.pushViewController(loginVC, animated: true)
                default: self.makeAlert(title: "오류", message: "네트워크를 확인해주세요")
            }
        }
    }
}

extension UserWithdrawalVC {
  
  // MARK: - Custom Method Part
  private func bindViewModels() {
    let input = UserWithdrawalViewModel.Input(viewWillAppearEvent:
                                                self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }, userInputText: nickNameTextField.rx.text.asObservable())
    let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    output.userNickname
      .subscribe(onNext: { [weak self] nickname in
        guard let self = self else { return }
        
      }).disposed(by: self.disposeBag)
    
    output.isMatchNickname
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] state in
        guard let self = self else { return }
        self.changeCTAButton.isEnabled = state!
      }).disposed(by: self.disposeBag)
  }
}

// MARK: - Keyboard Actions

extension UserWithdrawalVC {
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func unregisterForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      
      let bottomContraint = (keyboardHeight) * (-1)
      changeCTAButton.snp.updateConstraints { make in
        make.bottom.equalTo(view.safeAreaLayoutGuide).offset(bottomContraint)
      }
    }
    
    UIView.animate(withDuration: duration, delay: 0) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
    let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
    changeCTAButton.snp.updateConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
    }
    UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve)) {
      self.view.layoutIfNeeded()
    }
  }
}
