//
//  ScrapVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit

class ScrapVC: UIViewController {
    
    // MARK: - Properties
    
    private let scrapTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let scrapBackButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Scrap.beforeIcon, for: .normal)
        return btn
    }()
    
    private let scrapTitleLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    private let scrapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension ScrapVC {
    private func setUI() {
        
    }
    
    private func setLayout() {
        view.addSubviews(scrapTopView,
                         lineView,
                         scrapCollectionView)
        
        scrapTopView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        scrapTopView.addSubviews(scrapBackButton)
        
        scrapBackButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Network

extension ScrapVC {
    
}
