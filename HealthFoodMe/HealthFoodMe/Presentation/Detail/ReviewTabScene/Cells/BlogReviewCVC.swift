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
        lb.font = UIFont.NotoBold(size: 14)
        return lb
    }()
    
    private lazy var blogReviewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var blogReviewContentsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoRegular(size: 12)
        lb.numberOfLines = 4
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
    
    private var blogReviewWithImageStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.distribution = .equalSpacing
        st.alignment = .center
        st.spacing = 16
        return st
    }()
    
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitialLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        blogReviewWithImageStackView.removeFromSuperview()
        blogReviewStackView.removeFromSuperview()
    }
}

// MARK: - Extension

extension BlogReviewCVC {
    
    private func setInitialLayout() {
        contentView.addSubviews(reviewSeperatorView)
        blogReviewImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        blogReviewStackView.addArrangedSubviews(blogReviewTitleLabel, blogReviewContentsLabel)
        blogReviewWithImageStackView.addArrangedSubviews(blogReviewStackView, blogReviewImageView)
    }
    func setLayout(hasImage: Bool) {
        
        if hasImage {
            
            contentView.addSubview(blogReviewStackView)
            blogReviewWithImageStackView.addArrangedSubviews(blogReviewStackView, blogReviewImageView)
            contentView.addSubview(blogReviewWithImageStackView)
        } else {
            contentView.addSubview(blogReviewStackView)
            setLayoutWithoutImage()
        }

    }
    
    private func setLayoutWithImage() {
        reviewSeperatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        blogReviewWithImageStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(reviewSeperatorView.snp.top).offset(28)
        }
        contentView.layoutIfNeeded()
    }
    
    private func setLayoutWithoutImage() {
        reviewSeperatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        blogReviewStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(reviewSeperatorView.snp.top).offset(28)
        }
        contentView.layoutIfNeeded()
    }
    
    func setData(blogReviewData: BlogReviewDataModel) {
        blogReviewTitleLabel.text = blogReviewData.blogReviewTitle
        blogReviewContentsLabel.text = blogReviewData.blogReviewContents
        blogReviewImageView.image = UIImage(named: blogReviewData.blogReviewImageURL ?? "")
    }
}
