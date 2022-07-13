//
//  ReviewTabVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/13.
//

import UIKit

class ReviewTabVC: UIViewController {
    
    private var reviewHeaderView: UIView = {
       let view = UIView()
        
        return view
    }()
    
    private var reviewCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ReviewTabVC {
    private func setLayout() {
        
    }
}
