//
//  WithdrawalAlertView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/15.
//

import UIKit

import SnapKit

class WithdrawalAlertView: UIView {
    
    // MARK: - Properties
    
    let width = UIScreen.main.bounds.width
    weak var delegate: AlertDelegate?
    
    // MARK: - UI Components
    
    private var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoMedium(size: 16)
        return lb
    }()
    
    private var subtitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var firstButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mainRed
        btn.setTitleColor(UIColor.helfmeWhite, for: .normal)
        btn.setTitle(I18N.HelfmeAlert.no, for: .normal)
        btn.titleLabel?.font = .NotoBold(size: 15)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(didTapWithdrawalClose), for: .touchUpInside)
        return btn
    }()
    
    private lazy var secondButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .helfmeWhite
        btn.setTitleColor(UIColor.helfmeGray2, for: .normal)
        btn.setTitle(I18N.HelfmeAlert.withdrawalYes, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 12)
        btn.addTarget(self, action: #selector(didTapWithdrawal), for: .touchUpInside)
        return btn
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGray2
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @objc Methods

extension WithdrawalAlertView {
    @objc func didTapWithdrawal() {
        postObserverAction(.withdrawalButtonClicked)
        delegate?.alertDidTap()
    }
    
    @objc func didTapWithdrawalClose() {
        delegate?.alertDismiss()
    }
}

// MARK: - Methods

extension WithdrawalAlertView {
    func setData(title: String?, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        addSubviews(titleLabel,
                    subtitleLabel,
                    firstButton,
                    secondButton,
                    lineView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(width * (50/375))
        }
        
        firstButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(width * (20/375))
            $0.height.equalTo(44)
        }
        
        secondButton.snp.makeConstraints {
            $0.top.equalTo(firstButton.snp.bottom).offset(12)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(21)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(secondButton.snp.bottom).offset(-3)
            $0.leading.trailing.equalTo(secondButton)
            $0.height.equalTo(0.5)
        }
    }
}
