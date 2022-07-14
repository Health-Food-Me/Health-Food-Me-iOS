//
//  ReviewCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/13.
//

import UIKit

class ReviewCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    // MARK: - UI Components
    
    private var nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoMedium(size: 14)
        
        return lb
    }()
    
    private let starView: StarRatingView = {
        let st = StarRatingView(starScale: 40)
        st.spacing = 15
        st.rate = 2.95
        return st
    }()
    
    private let tagCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .helfmeWhite
        cv.showsHorizontalScrollIndicator = false
        
        return cv
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

extension ReviewCVC {
    func setDelegate() {
        //tagCV.delegate = self
        //tagCV.delegate = self
    }
    
    private func setLayout() {
        contentView.addSubviews(nameLabel, starView)
        }
}
//
//extension ReviewCVC: UICollectionViewDelegate {
//}
//
//extension ReviewCVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
//
//extension ReviewCVC: UICollectionViewDelegateFlowLayout {
//    
//}
