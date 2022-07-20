//
//  ScrapEmptyView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit

protocol ScrapEmptyViewDelegate: AnyObject {
    func scrapEmptyViewDidTap()
}

class ScrapEmptyView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ScrapEmptyViewDelegate?
    
    // MARK: - UI Components
    
    private let withHelpme: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Scrap.withHelfme
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 18)
        return lb
    }()
    
    private let dietStore: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Scrap.dietStore
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private lazy var scrapButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Scrap.goScrap, for: .normal)
        btn.backgroundColor = .mainRed
        btn.setTitleColor(UIColor.helfmeWhite, for: .normal)
        btn.titleLabel?.font = .NotoBold(size: 16)
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(popToMainMapVC), for: .touchUpInside)
        return btn
    }()
    
    private lazy var scrapStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubviews(withHelpme,
                               dietStore,
                               scrapButton)
        sv.alignment = .center
        sv.setCustomSpacing(14, after: withHelpme)
        sv.setCustomSpacing(10, after: dietStore)
        sv.axis = .vertical
        return sv
    }()
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @objc Methods

extension ScrapEmptyView {
    @objc func popToMainMapVC() {
        delegate?.scrapEmptyViewDidTap()
    }
}

// MARK: - Methods

extension ScrapEmptyView {
    private func setUI() {
        backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        addSubviews(scrapStackView)
        
        scrapStackView.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalTo(safeAreaLayoutGuide).offset(-48)
        }
        
        scrapButton.snp.makeConstraints {
            let btnWidth = UIScreen.main.bounds.width * (180/375)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnWidth * (44/180))
        }
    }
}
