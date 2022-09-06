//
//  ImageHeaderView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/09/01.
//

import UIKit
import SnapKit

class ImageHeaderView: UICollectionReusableView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    lazy var imageHeaderLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 15)
        lb.text =  I18N.Detail.Menu.imageHeader

        return lb
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ImageHeaderView {
    private func setLayout() {
        self.addSubviews(imageHeaderLabel)
        
        imageHeaderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
    }
}
