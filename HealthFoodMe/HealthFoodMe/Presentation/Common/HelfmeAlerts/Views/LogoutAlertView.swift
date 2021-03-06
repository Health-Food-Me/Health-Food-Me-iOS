//
//  LogoutAlertView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/15.
//

import UIKit

import SnapKit

protocol AlertDelegate: AnyObject {
    func alertDidTap()
    func alertDismiss()
}

final class LogoutAlertView: UIView {
    
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
        btn.setTitle(I18N.HelfmeAlert.yes, for: .normal)
        btn.titleLabel?.font = .NotoBold(size: 15)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return btn
    }()
    
    private lazy var secondButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .helfmeWhite
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.setTitle(I18N.HelfmeAlert.no, for: .normal)
        btn.titleLabel?.textColor = .helfmeGray1
        btn.titleLabel?.font = .NotoBold(size: 15)
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = UIColor.helfmeLineGray.cgColor
        btn.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        btn.layer.borderWidth = 1
        return btn
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

extension LogoutAlertView {
    @objc func didTapLogout() {
        delegate?.alertDidTap()
    }
    
    @objc func didTapClose() {
        delegate?.alertDismiss()
    }
}

// MARK: - Methods

extension LogoutAlertView {
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
                    secondButton)
        
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
            $0.top.equalTo(firstButton.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(width * (20/375))
            $0.height.equalTo(44)
        }
    }
}
