//
//  ReviewDetailVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/15.
//

import UIKit

import ImageSlideShowSwift

class ReviewDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let withImageAndContents = 0
    private let withImage = 1
    private let withContents = 2
    private let withoutImageAndContents = 3
    
    weak var delegate: ScrollDeliveryDelegate?
    var swipeDismissDelegate: SwipeDismissDelegate?
    var topScrollAnimationNotFinished: Bool = true
    private var reviewData: [ReviewCellViewModel] = [] { didSet {
        fetchCutStringList()
        fetchExpendStateList()
    }}
    private var reviewServerData: [ReviewDataModel] = []
    private var blogReviewData: [BlogReviewDataModel] = []
    private var cutLabelList: [String] = []
    private var expendStateList: [Bool] = []
    var moreContentsButtonRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var restaurantId: String = "62d26c9bd11146a81ef18ea6"
    var restaurantName: String = "샐러디태릉입구"
    
    var selectedCustomSegment = 0 {
        didSet {
            reviewCV.reloadData()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var reviewCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .helfmeWhite
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        
        return cv
    }()
    
    // MARK: - Life Cycle Part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setDelegate()
        registerCell()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        reviewCV.reloadData()
    }
}

// MARK: - Extension

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
    
    private func calculateTextInSize(review: String) -> (Int,String) {
        var calculatedText: String = ""
        var previousHeight: CGFloat = 0
        var lineCount: Int = 0
        
        for char in review {
            calculatedText += String(char)
            if (previousHeight != calculateReviewHeight(calculatedText)) {
                previousHeight = calculateReviewHeight(calculatedText)
                lineCount += 1
            }
            if lineCount == 4 {
                return (4,calculatedText)
            }
        }
        return (lineCount,calculatedText)
    }
    
    private func cutReviewContents(_ reviewDataContents: String) -> String {
        var eraseCount: Int = 0
        
        var (lineCount,cutText) = calculateTextInSize(review: reviewDataContents)
        if lineCount > 3 {
            
            for char in cutText {
                eraseCount += 1
                cutText.popLast()
                if eraseCount > 9 {
                    cutText.append("  더보기")
                    break
                } else {
                    if char == " " {
                        continue
                    }
                }
            }
        }
        
        return cutText
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
    
    private func caculateBlogReviewHeight() -> CGFloat {
        let textView = UITextView()
        textView.text =
"""
가
나
다
"""
        textView.font = .NotoRegular(size: 12)
        textView.sizeToFit()
        var contentHeight = textView.frame.height
        
        let titleTextView = UITextView()
        titleTextView.text = "제목"
        titleTextView.font = .NotoBold(size: 14)
        var titleHeight = titleTextView.frame.height
        
        var totalHeight = titleHeight + contentHeight + 10 + 28 + 28
        
        return totalHeight
        
    }
    
    private func addObserver() {
        addObserverAction(.reviewPhotoClicked) { noti in
            if let slideData = noti.object as? ImageSlideDataModel {
                self.clickPhotos(index: slideData.clickedIndex, urls: slideData.imgURLs)
            }
        }
    }
    
    func clickPhotos(index: Int,urls: [String]){
        let images :[ImageSlideShowProtocol] = urls.enumerated().map { index,url in
            
            ImageForSlide(title: "\(index+1)/\(urls.count)", url: URL(string: url)!)
        }
        
        ImageSlideShowViewController.presentFrom(self) { controller in
            controller.navigationBarTintColor = .black
            controller.navigationController?.navigationBar.backgroundColor = .black
            controller.navigationController?.navigationBar.barTintColor = .black
            controller.navigationController?.navigationBar.tintColor = .black
            controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            
            controller.dismissOnPanGesture = true
            controller.slides = images
            controller.enableZoom = true
            controller.initialIndex = index
            controller.view.backgroundColor = .black
        }
    }
    
    
    // MARK: - Network
    
    private func fetchCutStringList() {
        for viewModel in reviewData {
            if let reviewText = viewModel.data.reviewContents {
                let cutText = cutReviewContents(reviewText)
                cutLabelList.append(cutText)
            } else {
                cutLabelList.append("")
            }
        }
    }
    
    private func fetchExpendStateList() {
        expendStateList = Array<Bool>(repeating: false, count: reviewData.count)
    }
    
    private func fetchData() {
        // 데이터를 서버에서 받아와야 함
        requestReviewListWithAPI() {
            self.requestBlogReviewListWithAPI()
            self.processViewModel(self.reviewServerData, self.blogReviewData)        }
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
                                         blogReviewContents: blogReviewData.blogReviewContents,
                                         blogURL: blogReviewData.blogURL))
        }
        
        self.reviewData = reviewResult
        self.blogReviewData = blogReviewResult
    }
    
    private func requestReviewListWithAPI(completion: @escaping(()->Void)) {
        ReviewService.shared.requestReviewList(restaurantId: restaurantId) { networkResult in
            switch networkResult {
            case .success(let data):
                self.reviewServerData.removeAll()
                if let data = data as? [ReviewListEntity] {
                    for da in data {
                        self.reviewServerData.append(da.toDomain())
                    }
                    self.reviewServerData.reverse()
                    print(data, "성공")
                }
                
            case .networkFail:
                print("실패")
            default:
                break
            }
            completion()
        }
    }
    
    private func requestBlogReviewListWithAPI()  {
        ReviewService.shared.requestBlogReviewList(restaurantName: restaurantName) { networkResult in
            switch networkResult {
            case .success(let data):
                self.blogReviewData.removeAll()
                if let data = data as? BlogReviewListEntity {
                    self.blogReviewData = data.toDomain()
                    print("성공")
                }
            case .networkFail:
                print("실패")
            default:
                break
            }
            self.reviewCV.reloadData()
        }
    }
    
    // MARK: - loadWebview
    private func didTabBlogReview(blogReviewURL: String) {
        guard let blogURL = URL(string: blogReviewURL) else {return}
        let vc = WebViewVC(url: blogURL)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

extension ReviewDetailVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(velocity)
        print(targetContentOffset.pointee.y)
        if velocity.x == 0 &&
            velocity.y < 0 {
            self.swipeDismissDelegate?.swipeToDismiss()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        print(yVelocity)
        print(scrollView.contentOffset.y)
        if yVelocity > 300 && scrollView.contentOffset.y == 0 {
            delegate?.childViewScrollDidEnd(type: .menu)
            return
        }
        
        if yVelocity < 0 && topScrollAnimationNotFinished {
            print(reviewCV.isScrollEnabled)
            reviewCV.isScrollEnabled = false
        }
        delegate?.scrollStarted(velocity: yVelocity, scrollView: scrollView)
    }
    
    // 손가락을 놓을때 처리하는 부분
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(reviewCV.isScrollEnabled)
        reviewCV.isScrollEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            delegate?.childViewScrollDidEnd(type: .menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.currentTabMenu(.review)
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
                if reviewData.count == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewEmptyViewCVC.className, for: indexPath) as? ReviewEmptyViewCVC else { return UICollectionViewCell() }
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVC.className, for: indexPath) as? ReviewCVC else { return UICollectionViewCell() }
                    cell.reviewSeperatorView.isHidden = indexPath.item == 0
                    cell.clickedEvent = { clickedIndex in
                        self.expendStateList[clickedIndex].toggle()
                        self.reviewCV.reloadData()
                    }
                    
                    let isFoldRequired = reviewData[indexPath.row].foldRequired
                    if isFoldRequired {
                        let originalText = reviewData[indexPath.row].data.reviewContents
                        let cutText = cutLabelList[indexPath.row]
                        let reviewText = expendStateList[indexPath.row] ? originalText : cutText
                        cell.setData(reviewData: reviewData[indexPath.row].data,
                                     text: reviewText ?? "",
                                     isFoldRequired: true,
                                     expanded: expendStateList[indexPath.row])
                        
                    } else {
                        cell.setData(reviewData: reviewData[indexPath.row].data,
                                     text: reviewData[indexPath.row].data.reviewContents ?? "",
                                     isFoldRequired: false, expanded: false)
                    }
                    
                    // 레이아웃 분기처리 코드
                    cell.layoutEnumValue = setEnumValue(data: reviewData[indexPath.row].data)
                    cell.setLayout()
                    return cell
                }
            } else {
                if blogReviewData.count == 0 {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCustomSegment == 0 {
            
        } else if selectedCustomSegment == 1 {
            didTabBlogReview(blogReviewURL: blogReviewData[indexPath.row].blogURL)
        }
    }
}

extension ReviewDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: 58)
        case 1:
            if selectedCustomSegment == 0 {
                if reviewData.count == 0 {
                    let cellWidth = width
                    let cellHeight = width * 200/width
                    return CGSize(width: cellWidth, height: cellHeight)
                } else {
                    let cellWidth = width
                    let cellHeight = calculateReviewCellHeight(containsPhoto: reviewData[indexPath.row].data.reviewImageURLList?.count != 0,
                                                               reviewText: reviewData[indexPath.row].data.reviewContents,
                                                               isExpandState: expendStateList[indexPath.row])
                    
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            } else {
                if blogReviewData.count == 0 {
                    let cellWidth = width
                    let cellHeight = width * 200/width
                    return CGSize(width: cellWidth, height: cellHeight)
                } else {
                    let cellWidth = width * 335/375
                    let cellHeight = caculateBlogReviewHeight()
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    private func calculateReviewCellHeight(containsPhoto: Bool, reviewText: String?,isExpandState: Bool) -> CGFloat {
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
            if !isExpandState {
                cellHeight += (threeLineHeight + bottomPadding)
            } else {
                cellHeight += (textViewHeight + bottomPadding)
            }
        } else {
            cellHeight += (textViewHeight + bottomPadding)
        }
        
        return cellHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        }
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
