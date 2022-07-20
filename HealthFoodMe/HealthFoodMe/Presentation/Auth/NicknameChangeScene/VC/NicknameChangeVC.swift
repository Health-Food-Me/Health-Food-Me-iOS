//
//  ChangeNickNameVC.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NicknameChangeVC: UIViewController {
  // MARK: - Vars & Lets Part
  private let disposeBag = DisposeBag()
  private var confirmButtonClicked = PublishRelay<String?>()
  private let nicknameMaxLength = 12
  var viewModel: NicknameChangeViewModel!
  
  // MARK: - UI Component Part
  
  private var topTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoBold(size: 16)
    label.text = I18N.Auth.ChangeNickname.headerTitle
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
    label.text = I18N.Auth.ChangeNickname.guideText
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
  
  private var conditionDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoRegular(size: 12)
    label.textColor = UIColor.helfmeGray2
    label.numberOfLines = 0
    label.text = I18N.Auth.ChangeNickname.conditionText
    return label
  }()
  
  private var changeCTAButton: CTAButton = {
    let button = CTAButton(enableState: false, title: I18N.Auth.ChangeNickname.ctaButtonTitle)
    button.isEnabled = false
    return button
  }()
  
  private lazy var nicknameFormatErrorToastview: UpperToastView = {
    let toastView = UpperToastView(title: I18N.Auth.ChangeNickname.formatErrMessage)
    toastView.layer.cornerRadius = 20
    return toastView
  }()
  
  private lazy var nicknameDuplicatedToastView: UpperToastView = {
    let toastView = UpperToastView(title: I18N.Auth.ChangeNickname.duplicatedErrMessage)
    toastView.layer.cornerRadius = 20
    return toastView
  }()
  
  // MARK: - Life Cycle Part
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    setUIProperty()
    bindViewModels()
    bindTextField()
    addButtonAction()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    registerForKeyboardNotifications()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    unregisterForKeyboardNotifications()
  }
}

extension NicknameChangeVC {
  private func setLayout() {
    view.addSubviews(topTitleLabel, backButton, headerDividerView,
                     topGuideLabel, nicknameTextFieldContainerView,
                     conditionDescriptionLabel,
                     changeCTAButton, nicknameFormatErrorToastview, nicknameDuplicatedToastView)
    nicknameTextFieldContainerView.addSubview(nickNameTextField)
    
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
    
    nicknameTextFieldContainerView.snp.makeConstraints { make in
      make.top.equalTo(topGuideLabel.snp.bottom).offset(16)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(55)
    }
    
    conditionDescriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(nickNameTextField.snp.bottom).offset(16)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(40)
    }
    
    changeCTAButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(44)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
    }
    
    nicknameFormatErrorToastview.snp.makeConstraints { make in
      make.width.equalTo(300)
      make.height.equalTo(40)
      make.top.equalTo(-40)
      make.centerX.equalToSuperview()
    }
    
    nicknameDuplicatedToastView.snp.makeConstraints { make in
      make.width.equalTo(208)
      make.height.equalTo(40)
      make.top.equalTo(-40)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setUIProperty() {
    self.navigationController?.navigationBar.isHidden = true
    nickNameTextField.layer.cornerRadius = 5
    changeCTAButton.layer.cornerRadius = 22
  }
  
  private func addButtonAction() {
    changeCTAButton.press {
      self.confirmButtonClicked.accept(self.nickNameTextField.text)
    }
  }
}

extension NicknameChangeVC {
  
  // MARK: - Custom Method Part
  private func bindViewModels() {
    let input = NicknameChangeViewModel.Input(ctaButtonClickEvent: confirmButtonClicked.asObservable())
    let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    output.currentNicknameStatus
      .subscribe(onNext: { [weak self] status in
        guard let self = self else { return }
        
        self.showUpperToast(status)
        if status == .normal { self.hideUpperToast() }

      }).disposed(by: self.disposeBag)
  }
  
  private func bindTextField() {
    nickNameTextField.rx.text
      .subscribe(onNext: { [weak self] text in
        guard let nicknameText = text else {
          self?.changeCTAButton.isEnabled = false
          return
        }
        self?.changeCTAButton.isEnabled = !nicknameText.isEmpty
      }).disposed(by: self.disposeBag)
    
    nickNameTextField.rx.text
      .filter { $0 != nil}
      .filter { !$0!.isEmpty }
      .distinctUntilChanged()
      .subscribe { _ in
        self.cutMaxLabel()
        self.hideUpperToast()
      }.disposed(by: self.disposeBag)
  }
                 
  private func cutMaxLabel() {
    if let text = nickNameTextField.text {
      if text.count > nicknameMaxLength {
        let maxIndex = text.index(text.startIndex, offsetBy: nicknameMaxLength)
        let newString = String(text[text.startIndex..<maxIndex])
        nickNameTextField.text = newString
      }
    }
  }
}

extension NicknameChangeVC {
  private func showUpperToast(_ status: NicknameChangeStatus) {
    guard status != .normal else {
      // FIXME: - 이후에 Custom Alert 생성되면 바꿀 예정
      makeAlert(title: "알림", message: "닉네임 변경 성공! ^_^")
      return }
    
    makeVibrate()
    let topInset = calculateTopInset() * (-1)
    if status == .containsSpecialCharacter {
      nicknameFormatErrorToastview.snp.updateConstraints { make in
        make.top.equalTo(topInset + 12)
      }
    } else {
      nicknameDuplicatedToastView.snp.updateConstraints { make in
        make.top.equalTo(topInset + 12)
      }
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
    self.nicknameFormatErrorToastview.snp.updateConstraints { make in
      make.top.equalTo(-40)
    }
    self.nicknameDuplicatedToastView.snp.updateConstraints { make in
      make.top.equalTo(-40)
    }
    
    UIView.animate(withDuration: 0.5, delay: 0) {
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: - Keyboard Actions

extension NicknameChangeVC {
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
