//
//  TagCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/14.
//

import UIKit

class TagCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    // MARK: - UI Components
    
    private lazy var tagLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .mainRed
        lb.layer.cornerRadius = 11
        lb.layer.borderColor = UIColor.mainRed.cgColor
        lb.layer.borderWidth = 1.0
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

//MARK: - Extension

extension TagCVC {
    private func setLayout() {
        contentView.addSubviews(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
    }
}
