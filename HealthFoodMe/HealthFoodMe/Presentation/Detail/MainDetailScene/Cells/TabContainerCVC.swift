//
//  TabContainerCVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/06.
//

import UIKit

import SnapKit

final class TabContainerCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let restaurantNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "샐러디 태릉입구점"
        lb.textColor = .black
        return lb
    }()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Methods

extension TabContainerCVC {
    
    private func setLayout() {
        addSubview(restaurantNameLabel)
        
        restaurantNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
