//
//  ReviewPhotoCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/14.
//

import UIKit

class ReviewPhotoCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
  
    // MARK: - UI Components
    
    private lazy var reviewImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        return iv
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

extension ReviewPhotoCVC {
    func setLayout() {
        contentView.addSubviews(reviewImageView)
        
        let width = UIScreen.main.bounds.width
        
        reviewImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(width * 105/375)
        }
    }
    
    func setData(photoData: String) {
//        reviewImageView.setImage(with: )
    }
}
