//
//  BlogReviewCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/13.
//

import UIKit

class BlogReviewCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    private var imageData: UIImage?
    
    // MARK: - UI Components
    
    private lazy var blogReviewTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoBold(size: 15)
        
        return lb
    }()
    
    private lazy var blogReviewContentsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoRegular(size: 13)
        lb.numberOfLines = 3
        return lb
    }()
    
    lazy var reviewSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.helfmeCardlineGray
        return view
    }()
    
    private var blogReviewStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.distribution = .equalSpacing
        st.alignment = .leading
        st.spacing = 10
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

// MARK: - Extension

extension BlogReviewCVC {
    
    func setLayout() {
        contentView.addSubviews(reviewSeperatorView, blogReviewStackView)
        blogReviewStackView.addArrangedSubviews(blogReviewTitleLabel, blogReviewContentsLabel)
        
        reviewSeperatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        blogReviewStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(reviewSeperatorView.snp.top).offset(28)
        }
    }
    
    func setData(blogReviewData: BlogReviewDataModel) {
        blogReviewTitleLabel.text = blogReviewTitleLabel.htmlToString(blogReviewData.blogReviewTitle)?.string
        blogReviewContentsLabel.text = blogReviewTitleLabel.htmlToString(blogReviewData.blogReviewContents)?.string
    }
}
