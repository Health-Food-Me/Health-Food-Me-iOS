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

final class ChangeNicknameVC: UIViewController {
  // MARK: - Vars & Lets Part
  private let disposeBag = DisposeBag()
  private var confirmButtonClicked = PublishRelay<String?>()
  private let nicknameMaxLength = 12
  var viewModel: ChangeNicknameViewModel!
  
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
    button.setBackgroundImage(ImageLiterals.Common.beforeIcon, for: .normal)
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
    return label
  }()
  
  private var nickNameTextField: UITextField = {
    let textField = UITextField()
    textField.addLeftPadding(width: 16)
    textField.textColor = .helfmeBlack
    textField.font = UIFont.NotoMedium(size: 16)
    textField.clearButtonMode = .unlessEditing
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
    toastView.layer.cornerRadius = 77
    return toastView
  }()
  
  private lazy var nicknameDuplicatedToastView: UpperToastView = {
    let toastView = UpperToastView(title: I18N.Auth.ChangeNickname.duplicatedErrMessage)
    toastView.layer.cornerRadius = 77
    return toastView
  }()
  
  // MARK: - Life Cycle Part
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bindViewModels()
    addButtonAction()
  }
}

extension ChangeNicknameVC {
  private func setUI() {
    view.addSubviews(topTitleLabel, backButton, headerDividerView,
                     topGuideLabel, nickNameTextField, conditionDescriptionLabel,
                     changeCTAButton, nicknameFormatErrorToastview, nicknameDuplicatedToastView)
    
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
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(20)
    }
    
    nickNameTextField.snp.makeConstraints { make in
      make.top.equalTo(topGuideLabel.snp.bottom).offset(16)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(55)
    }
    
    conditionDescriptionLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(34)
    }
    
    changeCTAButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(20)
      make.height.equalTo(44)
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
  
  private func addButtonAction() {
    changeCTAButton.press {
      self.confirmButtonClicked.accept(self.nickNameTextField.text)
    }
  }
}

extension ChangeNicknameVC {
  
  // MARK: - Custom Method Part
  private func bindViewModels() {
    let input = ChangeNicknameViewModel.Input(ctaButtonClickEvent: confirmButtonClicked.asObservable())
    let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    output.currentNicknameStatus
      .subscribe(onNext: { [weak self] status in
        guard let self = self else { return }
        if status != .normal {
          self.showUpperToast(status)
        } else {
          self.hideUpperToast()
        }
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
      .orEmpty
      .distinctUntilChanged()
      .subscribe { _ in
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

extension ChangeNicknameVC {
  private func showUpperToast(_ status: NicknameStatus) {
    guard status != .normal else { return }
    
    if status == .containsSpecialCharacter {
      nicknameFormatErrorToastview.snp.updateConstraints { make in
        make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
      }
    } else {
      nicknameDuplicatedToastView.snp.updateConstraints { make in
        make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
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
