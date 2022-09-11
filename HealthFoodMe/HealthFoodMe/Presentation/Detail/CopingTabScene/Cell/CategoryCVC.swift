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
    override var isSelected: Bool {
        didSet {
            resetUI()
        }
    }
    
    // MARK: - UI Components
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.text = "샌드위치"
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
            self.layer.borderWidth = 0
            self.backgroundColor = .helfmeGreenSubDark
        } else {
            categoryLabel.textColor = .helfmeTagGray
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
