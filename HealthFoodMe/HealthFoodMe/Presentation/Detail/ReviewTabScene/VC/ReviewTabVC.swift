//
//  ReviewTabVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/14.
//

import UIKit

class ReviewTabVC: UIViewController {
    
    // MARK: - Property
    
    private let withImageAndContents = 0
    private let withImage = 1
    private let withContents = 2
    private let withoutImageAndContents = 3
    
    private var reviewData: [ReviewCellViewModel] = []

    // MARK: - UI Components
    
    private lazy var reviewCV: UICollectionView = {
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
        setLayout()
        setDelegate()
        registerCell()
    }
}

// MARK: - Extension

extension ReviewTabVC {
    func setDelegate() {
        reviewCV.delegate = self
        reviewCV.dataSource = self
    }
    
    private func setLayout() {
        view.addSubviews(reviewCV)
        
        reviewCV.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(20)
        }
    }
    
    private func registerCell() {
        ReviewCVC.register(target: reviewCV)
        ReviewHeaderCVC.register(target: reviewCV)
    }
    
    private func setEnumValue(data: ReviewDataModel) -> Int {
        if data.reviewImageURLList?.isEmpty == false {
            if data.reviewContents != nil {
                return withImageAndContents
            } else {
                return withImage
            }
        } else {
            if data.reviewContents != nil {
                return withContents
            } else {
                return withoutImageAndContents
            }
        }
    }
    
    private func processViewModel(_ dataList: [ReviewDataModel]) {
        var result: [ReviewCellViewModel] = []
        for data in dataList {
            let height = calculateReviewHeight(data.reviewContents ?? "")
            result.append(ReviewCellViewModel.init(data: data,
                                                   foldRequired: height > 55))
        }
        self.reviewData = result
    }
    
    private func calculateReviewHeight(_ text: String) -> CGFloat {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 0))
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.font = .NotoRegular(size: 12)
        textView.text = text
        textView.sizeToFit()
        return textView.frame.height
    }
}

extension ReviewTabVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension ReviewTabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return reviewData.count
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVC.className, for: indexPath) as? ReviewCVC else { return UICollectionViewCell() }
            cell.blogReviewSeperatorView.isHidden = indexPath.item == 0
            cell.setData(reviewData: ReviewDataModel.sampleData[indexPath.row])
            cell.setEnumValue = setEnumValue(data: ReviewDataModel.sampleData[indexPath.row])
            cell.setLayout()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ReviewTabVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        switch indexPath.section {
        case 0:
            let cellWidth = width * 226/375
            let cellHeight = cellWidth * 40/335
            return CGSize(width: cellWidth, height: cellHeight)
        case 1:
            let cellWidth = width * 355/375
            let cellHeight = calculateReviewCellHeight(containsPhoto: ReviewDataModel.sampleData[indexPath.row].reviewImageURLList?.count != 0,
                                                       reviewText: ReviewDataModel.sampleData[indexPath.row].reviewContents)
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
            
        }
    }
    
    private func calculateReviewCellHeight(containsPhoto: Bool, reviewText: String? ) -> CGFloat {
        var cellHeight: CGFloat = 0
        let topPadding: CGFloat = 28
        let nameLabelHeight: CGFloat = 20
        let tagHeight: CGFloat = 22
        let tagTopPadding: CGFloat = 10
        let tempPadding: CGFloat = 15
        let threeLineHeight: CGFloat = 51
        let bottomPadding: CGFloat = 28
        let imageBottomPadding: CGFloat = 12
        
        cellHeight += topPadding
        cellHeight += nameLabelHeight
        cellHeight += tagHeight
        cellHeight += tagTopPadding
        cellHeight += tempPadding
        
        if containsPhoto {
            cellHeight += (UIScreen.main.bounds.width * (105/375))
            cellHeight += imageBottomPadding
        }
        
        let textViewHeight = calculateReviewHeight(reviewText ?? "")
        if textViewHeight >= threeLineHeight {
            cellHeight += (threeLineHeight + bottomPadding)
        } else {
            cellHeight += (textViewHeight + bottomPadding)
        }
        
        return cellHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
