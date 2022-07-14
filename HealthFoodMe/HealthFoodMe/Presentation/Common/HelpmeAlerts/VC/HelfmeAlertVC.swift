//
//  HelfmeAlertVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/15.
//

import UIKit

import SnapKit

enum AlertType {
    case logoutAlert
    case deleteReviewAlert
    case withdrawalAlert
}

final class HelfmeAlertVC: UIViewController {
    
    // MARK: - Properties
    
    let width = UIScreen.main.bounds.width
    var alertType: AlertType = .logoutAlert
    var alertTitle: String? = nil
    var alertContent: String? = nil
    var okAction: (() -> Void)? = nil
  
    // MARK: - UI Components
    
    private let logoutAlertView: LogoutAlertView = {
        let view = LogoutAlertView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let reviewDeleteAlertView: ReviewDeleteAlertView = {
        let view = ReviewDeleteAlertView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let withdrawalAlertView: WithdrawalAlertView = {
        let view = WithdrawalAlertView()
        view.layer.cornerRadius = 15
        return view
    }()
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlert()
        setUI()
        setLayout()
        setDelegate()
    }
}

// MARK: - Methods

extension HelfmeAlertVC {
    private func setAlert() {
        switch alertType {
        case .logoutAlert:
            logoutAlertView.setData(title: I18N.HelfmeAlert.logout,
                                    subtitle: I18N.HelfmeAlert.logoutContent,
                                    firstBtn: I18N.HelfmeAlert.yes,
                                    secondBtn: I18N.HelfmeAlert.no)
            setAlertView(false, true, true)
        case .deleteReviewAlert:
            reviewDeleteAlertView.setData(title: I18N.HelfmeAlert.reviewDelete,
                                          firstBtn: I18N.HelfmeAlert.yes,
                                          secondBtn: I18N.HelfmeAlert.no)
            setAlertView(true, false, true)
        case .withdrawalAlert:
            withdrawalAlertView.setData(title: I18N.HelfmeAlert.withdrawal,
                                        subtitle: I18N.HelfmeAlert.withdrawalContent,
                                        firstBtn: I18N.HelfmeAlert.no,
                                        secondBtn: I18N.HelfmeAlert.withdrawalYes)
            setAlertView(true, true, false)
        }
    }
    
    private func setAlertView(_ logout: Bool, _ deleteReview: Bool, _ withdrawal: Bool) {
        logoutAlertView.isHidden = logout
        reviewDeleteAlertView.isHidden = deleteReview
        withdrawalAlertView.isHidden = withdrawal
    }
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func setLayout() {
        view.addSubviews(logoutAlertView,
                         reviewDeleteAlertView,
                         withdrawalAlertView)
        
        view.addSubviews(withdrawalAlertView)
        
        logoutAlertView.snp.makeConstraints {
            let logoutWidth = width * (288/375)
            $0.center.equalToSuperview()
            $0.width.equalTo(logoutWidth)
            $0.height.equalTo(logoutWidth * (241/288))
        }

        reviewDeleteAlertView.snp.makeConstraints {
            let reviewDeleteWidth = width * (288/375)
            $0.center.equalToSuperview()
            $0.width.equalTo(reviewDeleteWidth)
            $0.height.equalTo(reviewDeleteWidth * (223/288))
        }
        
        withdrawalAlertView.snp.makeConstraints {
            let withdrawalWidth = width * (288/375)
            $0.center.equalToSuperview()
            $0.width.equalTo(withdrawalWidth)
            $0.height.equalTo(withdrawalWidth * (222/288))
        }
    }
    
    private func setDelegate() {
        logoutAlertView.delegate = self
        reviewDeleteAlertView.delegate = self
        withdrawalAlertView.delegate = self
    }
    
    private func emptyActions() {
        
    }
}

// MARK: - AlertDelegate

extension HelfmeAlertVC: AlertDelegate {
    func alertDidTap() {
        dismiss(animated: false) {
            (self.okAction ?? self.emptyActions)()
        }
    }
    
    func alertDismiss() {
        dismiss(animated: false)
    }
}
