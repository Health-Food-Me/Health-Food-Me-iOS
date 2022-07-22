//
//  MyReviewEmptyViewCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/21.
//

import UIKit

protocol MyReviewEmptyViewDelegate: AnyObject {
    func myReviewEmptyViewDidTap()
}

class MyReviewEmptyViewCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    let btnWidth = UIScreen.main.bounds.width * (180/375)
    weak var delegate: MyReviewEmptyViewDelegate?
  
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
        lb.text = I18N.MyReview.enjoyRestaurant
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private lazy var myReviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.MyReview.gotoFindRestaurant, for: .normal)
        btn.backgroundColor = .mainRed
        btn.setTitleColor(UIColor.helfmeWhite, for: .normal)
        btn.titleLabel?.font = .NotoBold(size: 16)
        btn.layer.cornerRadius = btnWidth * (44/180) / 2
        btn.addTarget(self, action: #selector(popToMainVC), for: .touchUpInside)
        return btn
    }()
    
    private lazy var myReviewStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubviews(withHelpme,
                               dietStore,
                               myReviewButton)
        sv.alignment = .center
        sv.setCustomSpacing(14, after: withHelpme)
        sv.setCustomSpacing(10, after: dietStore)
        sv.axis = .vertical
        return sv
    }()
  
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MyReviewEmptyViewCVC {
    private func setUI() {
        backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        addSubviews(myReviewStackView)
        
        myReviewStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-48)
        }
        
        myReviewButton.snp.makeConstraints {
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnWidth * (44/180))
        }
    }
    
    @objc func popToMainVC() {
        delegate?.myReviewEmptyViewDidTap()
    }
}
