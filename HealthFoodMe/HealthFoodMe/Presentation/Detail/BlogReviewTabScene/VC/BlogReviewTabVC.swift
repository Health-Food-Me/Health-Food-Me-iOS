//
//  BlogReviewTabVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/13.
//

import UIKit

class BlogReviewTabVC: UIViewController {
    
    // MARK: - UI Components
    
//    private var reviewHeaderView: UIView = {
//        let view = UIView()
//        
//        return view
//    }()
    
    private let reviewSegmentControl: CustomSegmentControl = {
        let sc = CustomSegmentControl(titleList: ["리뷰", "블로그 리뷰"])
        return sc
    }()

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
    }
    
    private func setLayout() {
        view.addSubviews(reviewSegmentControl, blogReviewCV)
        
        reviewSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.centerX.equalToSuperview()
            make.width.equalTo(226)
            make.height.equalTo(40)
        }
        
        blogReviewCV.snp.makeConstraints { make in
            make.top.equalTo(reviewSegmentControl.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension BlogReviewTabVC: UICollectionViewDelegate {
    
}

extension BlogReviewTabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BlogReviewDataModel.sampleData.count
//        switch section{
//        case 0:
//            return 1
//        case 1:
//            return BlogReviewDataModel.sampleData.count
//        default:
//            return 0
//        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogReviewCVC.className, for: indexPath) as? BlogReviewCVC
                    else { return UICollectionViewCell() }
        
                    if indexPath.item == 0 {
                        cell.blogReviewSeperatorView.isHidden = true
                    } else {
                        cell.blogReviewSeperatorView.isHidden = false
                    }
                    cell.setData(blogReviewData: BlogReviewDataModel.sampleData[indexPath.row])
                    cell.setLayout()
                    return cell
//        switch indexPath.section {
//        case 0:
//            let view = reviewSegmentControl
//            return view
//        case 1:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogReviewCVC.className, for: indexPath) as? BlogReviewCVC
//            else { return UICollectionViewCell() }
//
//            if indexPath.item == 0 {
//                cell.blogReviewSeperatorView.isHidden = true
//            } else {
//                cell.blogReviewSeperatorView.isHidden = false
//            }
//            cell.setData(blogReviewData: BlogReviewDataModel.sampleData[indexPath.row])
//            cell.setLayout()
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
        
    }
    
}

extension BlogReviewTabVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        let cellWidth = width * 335/375
        let cellHeight = cellWidth * 158/335
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
