//
//  SettingVC.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/15.
//

import UIKit
import MessageUI
import NMapsMap

class SettingVC: UIViewController {
    
    // MARK: - Properties
    
    private let schemeManager = URLSchemeManager.shared
    
    // MARK: - UI Components
    
    private var topTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .NotoBold(size: 16)
        label.text = I18N.Map.HamburgerBar.setting
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
    
    private lazy var customerServiceTitle: UILabel = {
        let label = UILabel()
        label.text = I18N.Setting.customerServiceTitle
        label.font = .NotoRegular(size: 14)
        label.textColor = UIColor.helfmeGray2
        return label
    }()
    
    private lazy var askButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Setting.askButtonTitle, for: .normal)
        button.setTitleColor(UIColor.helfmeBlack, for: .normal)
        button.titleLabel?.font = .NotoRegular(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Setting.userWithdrawalTitle, for: .normal)
        button.setTitleColor(UIColor.helfmeBlack, for: .normal)
        button.titleLabel?.font = .NotoRegular(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Setting.reportTitle, for: .normal)
        button.setTitleColor(UIColor.helfmeBlack, for: .normal)
        button.titleLabel?.font = .NotoRegular(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var termsTitle: UILabel = {
        let label = UILabel()
        label.text = I18N.Setting.termsTitle
        label.font = .NotoRegular(size: 14)
        label.textColor = UIColor.helfmeGray2
        return label
    }()
    
    private lazy var openSourceButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Setting.openSourceButtonTitle, for: .normal)
        button.setTitleColor(UIColor.helfmeBlack, for: .normal)
        button.titleLabel?.font = .NotoRegular(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var naverMapTermsButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Setting.naverMapTerms, for: .normal)
        button.setTitleColor(UIColor.helfmeBlack, for: .normal)
        button.titleLabel?.font = .NotoRegular(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var naverMapLicenseButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Setting.naverMapLicense, for: .normal)
        button.setTitleColor(UIColor.helfmeBlack, for: .normal)
        button.titleLabel?.font = .NotoRegular(size: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addButtonAction()
    }
}

// MARK: - Methods

extension SettingVC {
    private func setLayout() {
        view.addSubviews(topTitleLabel, backButton, headerDividerView,
                         customerServiceTitle, askButton, withdrawalButton, reportButton,
                         termsTitle, openSourceButton, naverMapTermsButton, naverMapLicenseButton)
        
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
        
        customerServiceTitle.snp.makeConstraints { make in
            make.top.equalTo(headerDividerView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        askButton.snp.makeConstraints { make in
            make.top.equalTo(customerServiceTitle.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
        
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(withdrawalButton.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.top.equalTo(askButton.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
        
        termsTitle.snp.makeConstraints { make in
            make.top.equalTo(reportButton.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        openSourceButton.snp.makeConstraints { make in
            make.top.equalTo(termsTitle.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
        
        naverMapTermsButton.snp.makeConstraints { make in
            make.top.equalTo(openSourceButton.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
        
        naverMapLicenseButton.snp.makeConstraints { make in
            make.top.equalTo(naverMapTermsButton.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
    }
    
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Methods

extension SettingVC {
    private func addButtonAction() {
        askButton.press(animated: false) {
            self.presentReportMail(title: I18N.Setting.askButtonTitle, content: I18N.Setting.askMailContent)
        }
        
        reportButton.press(animated: false) {
            self.presentReportMail(title: I18N.Setting.reportTitle, content: I18N.Setting.reportMailContent)
        }
    
        withdrawalButton.press(animated: false) {
            let withdrawlVC = ModuleFactory.resolve().makeUserWithdrawlVC()
            self.navigationController?.pushViewController(withdrawlVC, animated: true)
        }
        
        openSourceButton.press(animated: false) {
            self.schemeManager.loadSafariApp(blogLink: NaverTerms.serviceTerm.rawValue)
        }
        
        naverMapTermsButton.press(animated: false) {
            self.schemeManager.loadSafariApp(blogLink: NaverTerms.naverMapTerm.rawValue)
        }
        
        naverMapLicenseButton.press(animated: false) {
            self.schemeManager.loadSafariApp(blogLink: NaverTerms.naverMapOpensource.rawValue)
        }
    }
}

extension SettingVC: MFMailComposeViewControllerDelegate {
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
