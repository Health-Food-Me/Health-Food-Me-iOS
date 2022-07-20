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
    
    private lazy var tagTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .mainRed
        tv.font = UIFont.NotoRegular(size: 10)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = .zero
        tv.textAlignment = .center
        return tv
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

extension TagCVC {
    private func setLayout() {
        contentView.addSubviews(tagTextView)
        
        tagTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalToSuperview().offset(-8)

        }
    }
    
    func setData(tagData: String) {
        tagTextView.text = tagData
    }
}
