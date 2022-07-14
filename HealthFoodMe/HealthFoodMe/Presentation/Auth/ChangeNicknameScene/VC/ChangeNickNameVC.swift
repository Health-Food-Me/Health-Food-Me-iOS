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

final class ChangeNickNameVC: UIViewController {
  // MARK: - Vars & Lets Part
  private let disposeBag = DisposeBag()
  var viewModel: ChangeNicknameViewModel!
  
  // MARK: - UI Component Part
  
  private var topTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoBold(size: 16)
    label.text = "프로필 편집"
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
    label.text = "* 특수문자, 이모티콘은 사용 불가합니다\n* 띄어쓰기 포함 최대 12글자"
    return label
  }()
  
  private var changeCTAButton: CTAButton = {
    let button = CTAButton(enableState: false, title: "수정 완료")
    button.isEnabled = false
    button.press { }
    return button
  }()
  
  private lazy var toastView: UpperToastView = {
    let toastView = UpperToastView(title: "닉네임 설정 기준에 적합하지 않습니다")
    toastView.layer.cornerRadius = 77
    return toastView
  }()
  
  // MARK: - Life Cycle Part
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bindViewModels()
  }
}

extension ChangeNickNameVC {
  private func setUI() {
    view.addSubviews(topTitleLabel, backButton, headerDividerView,
                     topGuideLabel, nickNameTextField, conditionDescriptionLabel,
                     changeCTAButton, toastView)
    
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
    
    toastView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(38)
      make.trailing.equalToSuperview().offset(-38)
      make.height.equalTo(40)
      make.top.equalTo(-40)
    }
  }
}

extension ChangeNickNameVC {
  
  // MARK: - Custom Method Part
  private func bindViewModels() {
    let input = ChangeNicknameViewModel.Input(nicknameText: nickNameTextField.rx.text.asObservable(),
                                              ctaButtonClickEvent: changeCTAButton.rx.tap.asObservable())
    let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    output.nicknameChangeSuccess
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        
      }).disposed(by: self.disposeBag)
  }
}
