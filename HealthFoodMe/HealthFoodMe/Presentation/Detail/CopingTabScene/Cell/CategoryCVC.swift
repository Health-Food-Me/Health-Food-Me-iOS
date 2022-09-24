//
//  CategoryCVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/09/07.
//

import UIKit

import SnapKit

class CategoryCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
  
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .NotoMedium(size: 15)
        return lb
    }()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CategoryCVC {
    internal func setCategoryData(name: String, isClicked: Bool) {
        categoryLabel.text = name
        categoryLabel.textColor = isClicked ? .helfmeWhite : .helfmeTagGray
        categoryLabel.font = isClicked ? UIFont.NotoBold(size: 14) : UIFont.NotoMedium(size: 14)
        self.layer.borderWidth = 1
        self.layer.borderColor = isClicked ? UIColor.clear.cgColor : UIColor.helfmeLineGray.cgColor
        self.backgroundColor = isClicked ? .helfmeGreenSubDark : .helfmeWhite
        
    }
}

extension CategoryCVC {
    private func setUI() {
        self.layer.cornerRadius = 16
        categoryLabel.textColor = .helfmeTagGray
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.helfmeLineGray.cgColor
        self.backgroundColor = .helfmeWhite
    }
    
    private func resetUI() {
        if isSelected {
            categoryLabel.textColor = .helfmeWhite
            categoryLabel.font = UIFont.NotoBold(size: 14)
            self.layer.borderWidth = 0
            self.backgroundColor = .helfmeGreenSubDark
        } else {
            categoryLabel.textColor = .helfmeTagGray
            categoryLabel.font = UIFont.NotoMedium(size: 14)
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.helfmeLineGray.cgColor
            self.backgroundColor = .helfmeWhite
        }
    }
    
    private func setLayout() {
        self.addSubviews(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
