//
//  ReviewHeaderCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/14.
//

import UIKit

protocol ReviewHeaderDelegate: AnyObject {
    func segmentIndexClicked(idx: Int)
}

class ReviewHeaderCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    weak var delegate: ReviewHeaderDelegate?
    
    // MARK: - UI Components
    
    private let reviewSegmentControl: CustomSegmentControl = {
        let sc = CustomSegmentControl(titleList: ["리뷰", "블로그 리뷰"])
        return sc
    }()
    
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setSegmentControlValue()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension ReviewHeaderCVC {
    private func setLayout() {
        contentView.addSubviews(reviewSegmentControl)
        
        reviewSegmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(226)
            make.height.equalTo(40)
        }
    }
    
    private func setSegmentControlValue() {
        reviewSegmentControl.areaClickEvent = { clickedIdx in
            self.delegate?.segmentIndexClicked(idx: clickedIdx)
        }
    }

}
