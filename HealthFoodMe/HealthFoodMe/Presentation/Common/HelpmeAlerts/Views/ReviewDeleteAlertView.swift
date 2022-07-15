//
//  ReviewDeleteAlertView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/15.
//

import UIKit

import SnapKit

class ReviewDeleteAlertView: UIView {
    
    // MARK: - Properties
    
    let width = UIScreen.main.bounds.width
    weak var delegate: AlertDelegate?
    
    // MARK: - UI Components
    
    private var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoMedium(size: 16)
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
        btn.addTarget(self, action: #selector(didTapReviewDelete), for: .touchUpInside)
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
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(didTapReviewDeleteClose), for: .touchUpInside)
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

extension ReviewDeleteAlertView {
    @objc func didTapReviewDelete() {
        delegate?.alertDidTap()
    }
    
    @objc func didTapReviewDeleteClose() {
        delegate?.alertDismiss()
    }
}

// MARK: - Methods

extension ReviewDeleteAlertView {
    func setData(title: String?) {
        titleLabel.text = title
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        addSubviews(titleLabel,
                    firstButton,
                    secondButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(30)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        firstButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
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
