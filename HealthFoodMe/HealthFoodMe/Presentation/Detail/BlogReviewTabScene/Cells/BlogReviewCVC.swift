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
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoBold(size: 14)
        return lb
    }()
    
    private lazy var blogReviewImageView: UIImageView? = {
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
    
    lazy var blogReviewSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension BlogReviewCVC {
    func setLayout() {
        if blogReviewImageView?.image != nil {
            blogReviewStackView.addArrangedSubviews(blogReviewTitleLabel, blogReviewContentsLabel)
            blogReviewImageView?.snp.makeConstraints({ make in
                make.width.height.equalTo(100)
            })
            blogReviewWithImageStackView.addArrangedSubviews(blogReviewStackView, blogReviewImageView!)
            setLayoutWithImage()
        } else {
            blogReviewStackView.addArrangedSubviews(blogReviewTitleLabel, blogReviewContentsLabel)
            setLayoutWithoutImage()
        }

    }
    
    private func setLayoutWithImage() {
        contentView.addSubviews(blogReviewSeperatorView, blogReviewWithImageStackView)
        
        blogReviewSeperatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
        
        blogReviewWithImageStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setLayoutWithoutImage() {
        contentView.addSubviews(blogReviewSeperatorView, blogReviewStackView)
        
        blogReviewSeperatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
        
        blogReviewStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setData(blogReviewData: BlogReviewDataModel) {
        blogReviewTitleLabel.text = blogReviewData.blogReviewTitle
        blogReviewContentsLabel.text = blogReviewData.blogReviewContents
        blogReviewImageView?.image = UIImage(named: blogReviewData.blogReviewImage ?? "")
    }
}
