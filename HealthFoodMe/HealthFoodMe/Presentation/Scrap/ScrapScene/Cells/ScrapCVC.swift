//
//  ScrapCVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit

class ScrapCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
  
    // MARK: - UI Components
  
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

extension ScrapCVC {
    private func setUI() {
        
    }
    
    private func setLayout() {
        
    }
}
