//
//  BlogReviewTabVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/13.
//

import UIKit

class BlogReviewTabVC: UIViewController {
    
    // MARK: - UI Components

    private lazy var blogReviewCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .helfmeWhite
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setUI()
        setLayout()
        registerCell()
    }
}

// MARK: - Extension

extension BlogReviewTabVC {
    func setDelegate() {
        blogReviewCV.delegate = self
        blogReviewCV.dataSource = self
    }
    
    private func setUI() {
        view.backgroundColor = .helfmeWhite
    }
    
    private func registerCell() {
        BlogReviewCVC.register(target: blogReviewCV)
        ReviewHeaderCVC.register(target: blogReviewCV)
    }
    
    private func setLayout() {
        view.addSubviews(blogReviewCV)
        
        blogReviewCV.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension BlogReviewTabVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension BlogReviewTabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return BlogReviewDataModel.sampleData.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewHeaderCVC.className, for: indexPath)
            return header
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogReviewCVC.className, for: indexPath) as? BlogReviewCVC
            else { return UICollectionViewCell() }

            cell.blogReviewSeperatorView.isHidden = indexPath.item == 0
            cell.setData(blogReviewData: BlogReviewDataModel.sampleData[indexPath.row])
            cell.setLayout()
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
}

extension BlogReviewTabVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        switch indexPath.section {
        case 0:
            let cellWidth = width * 226/375
            let cellHeight = cellWidth * 40/335
            return CGSize(width: cellWidth, height: cellHeight)
        case 1:
            let cellWidth = width * 335/375
            let cellHeight = cellWidth * 158/335
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
