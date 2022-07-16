//
//  ReviewEmptyViewCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/16.
//

import UIKit

class ReviewEmptyViewCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    // MARK: - UI Components
    private var testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SDFSDFSDF"
        return lb
    }()
    
    private var reviewEmptyViewImageView: UIImageView = {
        let iv = UIImageView()
        let image = ImageLiterals.ReviewDetail.reviewEmptyIcon
        iv.image = image
        return iv
    }()
    
    private var reviewEmptyViewLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.emptyViewMessage
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private var reviewEmptyStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 24
        st.distribution = .equalSpacing
        st.alignment = .center
        return st
    }()
  
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Methods

extension ReviewEmptyViewCVC {
    private func setLayout() {
        
        let width = UIScreen.main.bounds.width
        reviewEmptyStackView.addArrangedSubviews(reviewEmptyViewImageView,
                                                 reviewEmptyViewLabel)
        contentView.addSubviews(reviewEmptyStackView)
        reviewEmptyStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
            make.width.equalTo(width - 211)
        }
    }
}
