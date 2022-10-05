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
    var alertTitle: String?
    var alertContent: String?
    var okAction: (() -> Void)?
    var closeAction: (()->Void)?
    
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
            logoutAlertView.setData(title: alertTitle, subtitle: alertContent)
            setAlertView(logout: false, deleteReview: true, withdrawal: true)
        case .deleteReviewAlert:
            reviewDeleteAlertView.setData(title: alertTitle)
            setAlertView(logout: true, deleteReview: false, withdrawal: true)
        case .withdrawalAlert:
            withdrawalAlertView.setData(title: alertTitle, subtitle: alertContent)
            setAlertView(logout: true, deleteReview: true, withdrawal: false)
        }
    }
    
    private func setAlertView(logout: Bool, deleteReview: Bool, withdrawal: Bool) {
        logoutAlertView.isHidden = logout
        reviewDeleteAlertView.isHidden = deleteReview
        withdrawalAlertView.isHidden = withdrawal
    }
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
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
        dismiss(animated: true)
        self.closeAction?()
    }
}
