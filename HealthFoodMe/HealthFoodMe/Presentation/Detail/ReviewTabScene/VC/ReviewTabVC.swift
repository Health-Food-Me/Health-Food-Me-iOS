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
            return ReviewDataModel.sampleData.count
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
//            let cellHeight = width * 400/355
            let cellHeight = calculateReviewCellHeight(containsPhoto: ReviewDataModel.sampleData[indexPath.row].reviewImageURLList?.count != nil,
                                                       reviewText: ReviewDataModel.sampleData[indexPath.row].reviewContents)
            print("길이 출력 되나???",
                  calculateReviewHeight(String(ReviewDataModel.sampleData[indexPath.row].reviewContents ?? "")))
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
            
        }
    }
    
    private func calculateReviewCellHeight(containsPhoto: Bool, reviewText: String? ) -> CGFloat {
        var cellHeight: CGFloat = 0
        
        cellHeight += 28
        cellHeight += 20
        cellHeight += 22
        cellHeight += 10
        
        if containsPhoto {
            cellHeight += (UIScreen.main.bounds.width * (105/375))
            cellHeight += 12
        }
        
        print("reviewText", reviewText ?? "")
        let textViewHeight = calculateReviewHeight(reviewText ?? "")
        print(textViewHeight)
        if textViewHeight >= 51 {
            cellHeight += (51 + 28)
        } else {
            cellHeight += (textViewHeight + 28)
        }
//        if isFold && textViewHeight >= 51 {
//            cellHeight += (51 + 28)
//        } else {
//            cellHeight += (textViewHeight + 28)
//        }
        
        return cellHeight
    }
    
    private func calculateReviewHeight(_ text: String) -> CGFloat {
        let textView = UITextView()
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.font = .NotoRegular(size: 12)
        textView.text = text
        textView.sizeToFit()
        return textView.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
