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
    
    // MARK: - UI Components
    
    private lazy var blogReviewTitleLabel: UILabel = {
        let lb = UILabel()
        
        return lb
    }()
    
    private lazy var blogReviewImageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    private lazy var blogReviewContentsLabel: UILabel = {
        let lb = UILabel()
        
        return lb
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
    private func setLayout() {
        contentView.addSubviews(blogReviewTitleLabel, blogReviewContentsLabel, blogReviewImageView)
        
        blogReviewTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        blogReviewContentsLabel.snp.makeConstraints { make in
            make.top.equalTo(blogReviewTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        blogReviewImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(blogReviewTitleLabel.snp.trailing).offset(16)
        }
    }
    
    private func setData(blogReviewData: BlogReviewDataModel) {
        blogReviewTitleLabel.text = blogReviewData.blogReviewTitle
        blogReviewContentsLabel.text = blogReviewData.blogReviewContents
        blogReviewImageView.image = UIImage(named: blogReviewData.blogReviewImage ?? "")
    }
}
