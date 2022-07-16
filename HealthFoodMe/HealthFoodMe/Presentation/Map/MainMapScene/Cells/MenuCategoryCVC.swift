//
//  MenuCategoryCVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/12.
//

import UIKit

import SnapKit

final class MenuCategoryCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    override var isSelected: Bool {
        didSet {
            resetUI()
        }
    }
    var isDietMenu: Bool = true
    private var originalImage: UIImage = UIImage()
    
    // MARK: - UI Components
    
    private let menuImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = UIImage()
        iv.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iv.tintColor = .helfmeWhite
        return iv
    }()
    
    private let menuNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = .black
        lb.font = .NotoRegular(size: 14)
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

// MARK: Methods

extension MenuCategoryCVC {
    private func setUI() {
        self.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        self.layer.cornerRadius = 16
        self.backgroundColor = .white
    }
    
    private func resetUI() {
        if isSelected {
            menuNameLabel.textColor = .helfmeWhite
            menuImageView.image = menuImageView.image?.withRenderingMode(.alwaysTemplate)
            self.backgroundColor = isDietMenu ? .helfmeGreenSubDark : .mainRed
        } else {
            menuNameLabel.textColor = .helfmeBlack
            menuImageView.image = originalImage
            self.backgroundColor = .helfmeWhite
        }
    }
    
    private func setLayout() {
        self.addSubviews(menuImageView, menuNameLabel)
        
        menuImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().inset(8)
        }
        
        menuNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(menuImageView.snp.centerY)
            make.leading.equalTo(menuImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func setData(data: MainMapCategory) {
        self.menuNameLabel.text = data.menuName
        self.menuImageView.image = data.menuIcon
        self.originalImage = data.menuIcon
    }
}
