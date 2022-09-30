//
//  TagSummaryCollectionView.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/12.
//

import UIKit

import SnapKit

final class TagSummaryCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let tagLabel: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = .mainRed
        lb.font = .NotoMedium(size: 10)
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

extension TagSummaryCVC {
    private func setUI() {
        self.layer.cornerRadius = 9
        self.layer.borderColor = UIColor.mainRed.cgColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.addSubviews(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setData(tag: String) {
        self.tagLabel.text = tag
    }
}
