//
//  ReviewDetailVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/15.
//

import UIKit

class ReviewDetailVC: UIViewController {

    private let withImageAndContents = 0
    private let withImage = 1
    private let withContents = 2
    private let withoutImageAndContents = 3
    
    private var reviewData: [ReviewCellViewModel] = []
    private var blogReviewData: [BlogReviewDataModel] = []
    
    var selectedCustomSegment = 0 {
        didSet {
            reviewCV.reloadData()
        }
    }
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setDelegate()
        registerCell()
        fetchData()
    }
}

extension ReviewDetailVC {
    func setDelegate() {
        reviewCV.delegate = self
        reviewCV.dataSource = self
    }
    
    private func setUI() {
        view.backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        view.addSubviews(reviewCV)
        
        reviewCV.snp.makeConstraints { make in
            make.top.trailing.bottom.leading.equalToSuperview()
        }
    }
    
    private func registerCell() {
        ReviewCVC.register(target: reviewCV)
        ReviewHeaderCVC.register(target: reviewCV)
        BlogReviewCVC.register(target: reviewCV)
        ReviewHeaderCVC.register(target: reviewCV)
        ReviewEmptyViewCVC.register(target: reviewCV)
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
    
    private func fetchData() {
        // 데이터를 서버에서 받아와야 함
        let reviewData = ReviewDataModel.sampleData // 서버에서 받아와야 할 데이터
        let blogReviewData = BlogReviewDataModel.sampleData
        processViewModel(reviewData, blogReviewData)
    }
    
    private func processViewModel(_ reviewDataList: [ReviewDataModel],
                                  _ blogReviewDataList: [BlogReviewDataModel]) {
        var reviewResult: [ReviewCellViewModel] = []
        var blogReviewResult: [BlogReviewDataModel] = []
        for reviewData in reviewDataList {
            let height = calculateReviewHeight(reviewData.reviewContents ?? "")
            reviewResult.append(ReviewCellViewModel.init(data: reviewData,
                                                   foldRequired: height > 55))
        }
        
        for blogReviewData in blogReviewDataList {
            blogReviewResult.append(
                BlogReviewDataModel.init(blogReviewTitle: blogReviewData.blogReviewTitle,
                                         blogReviewContents: blogReviewData.blogReviewContents))
        }
        
        self.reviewData = reviewResult
        self.blogReviewData = blogReviewResult
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

extension ReviewDetailVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension ReviewDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if selectedCustomSegment == 0 {
                if reviewData.count == 0 {
                    return 1
                } else {
                    return reviewData.count
                }
            } else {
                if blogReviewData.count == 0 {
                    return 1
                } else {
                    return blogReviewData.count
                }
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let header = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewHeaderCVC.className, for: indexPath) as? ReviewHeaderCVC else { return UICollectionViewCell() }
            header.delegate = self
            
            return header
        case 1:
            if selectedCustomSegment == 0 {
                if ReviewDataModel.sampleData.count == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewEmptyViewCVC.className, for: indexPath) as? ReviewEmptyViewCVC else { return UICollectionViewCell() }
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVC.className, for: indexPath) as? ReviewCVC else { return UICollectionViewCell() }
                    cell.reviewSeperatorView.isHidden = indexPath.item == 0
                    cell.setData(reviewData: reviewData[indexPath.row].data)
                    cell.setEnumValue = setEnumValue(data: reviewData[indexPath.row].data)
                    cell.setLayout()
                    return cell
                }
            } else {
                if BlogReviewDataModel.sampleData.count == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewEmptyViewCVC.className, for: indexPath) as? ReviewEmptyViewCVC else { return UICollectionViewCell() }
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogReviewCVC.className, for: indexPath) as? BlogReviewCVC
                    else { return UICollectionViewCell() }
                    cell.reviewSeperatorView.isHidden = indexPath.item == 0
                    cell.setData(blogReviewData: blogReviewData[indexPath.row])
                    return cell
                }
            }
        default:
            return UICollectionViewCell()
        }
    }
}

extension ReviewDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        switch indexPath.section {
        case 0:
            let cellWidth = width * 226/375
            let cellHeight = cellWidth * 40/335
            return CGSize(width: cellWidth, height: cellHeight)
        case 1:
            if selectedCustomSegment == 0 {
                if ReviewDataModel.sampleData.count == 0 {
                    let cellWidth = width
                    let cellHeight = width * 200/width
                    return CGSize(width: cellWidth, height: cellHeight)
                } else {
                    let cellWidth = width
                    print("index", indexPath.row)
                    let cellHeight = calculateReviewCellHeight(containsPhoto: reviewData[indexPath.row].data.reviewImageURLList?.count != 0,
                                                               reviewText: reviewData[indexPath.row].data.reviewContents)
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            } else {
                if blogReviewData.count == 0 {
                    let cellWidth = width
                    let cellHeight = width * 200/width
                    return CGSize(width: cellWidth, height: cellHeight)
                } else {
                    let cellWidth = width * 335/375
                    let cellHeight = cellWidth * 158/335
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
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

extension ReviewDetailVC: ReviewHeaderDelegate {
    func segmentIndexClicked(idx: Int) {
        selectedCustomSegment = idx
    }
}
