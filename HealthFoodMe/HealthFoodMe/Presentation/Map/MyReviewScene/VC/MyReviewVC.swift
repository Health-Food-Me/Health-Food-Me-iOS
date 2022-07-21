//
//  MyReviewVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import UIKit

import RxSwift

class MyReviewVC: UIViewController {
    
    // MARK: - Properties
    var isEdited: Bool = true // 리뷰 수정
    
    private let withImageAndContents = 0
    private let withImage = 1
    private let withContents = 2
    private let withoutImageAndContents = 3
    
    private var reviewData: [MyReviewCellViewModel] = [] { didSet {
        fetchCutStringList()
        fetchExpendStateList()
        reviewCV.reloadData()
    }}
    private var reviewServerData: [MyReviewModel] = []
    private var cutLabelList: [String] = []
    private var expendStateList: [Bool] = []
    
    private let disposeBag = DisposeBag()
    var viewModel: MyReviewViewModel!
    
    // MARK: - UI Components
    
    private let statusTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var customNavigationBar: HelfmeNaviBar = {
        let view = HelfmeNaviBar()
        view.setTitleView(title: I18N.MyReview.myReviewTitle)
        view.buttonClosure = {
            self.popViewController()
        }
        return view
    }()
    
    private lazy var reviewCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .helfmeWhite
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        setLayout()
        setDelegate()
        registerCell()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        resetUI()
        fetchData()
        reviewCV.reloadData()
    }
}

// MARK: - Methods

extension MyReviewVC {
    
    private func bindViewModels() {
        let input = MyReviewViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    func setDelegate() {
        reviewCV.delegate = self
        reviewCV.dataSource = self
    }
    
    private func setUI() {
        view.backgroundColor = .helfmeWhite
        customNavigationBar.setTitleView(title: "내가 쓴 리뷰")
    }
    
    private func resetUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(statusTopView, customNavigationBar, reviewCV)
        
        statusTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(customNavigationBar.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        reviewCV.snp.makeConstraints { make in
            make.trailing.bottom.leading.equalToSuperview()
            make.top.equalTo(customNavigationBar.snp.bottom)
        }
    }
    
    private func registerCell() {
        MyReviewCVC.register(target: reviewCV)
        MyReviewEmptyViewCVC.register(target: reviewCV)
    }
    
    private func setEnumValue(data: MyReviewModel) -> Int {
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
        requestReviewListWithAPI()
    }
    
    private func processViewModel(_ reviewDataList: [MyReviewModel]) {
        var reviewResult: [MyReviewCellViewModel] = []
        for reviewData in reviewDataList {
            let height = calculateReviewHeight(reviewData.reviewContents ?? "")
            reviewResult.append(MyReviewCellViewModel.init(data: reviewData,
                                                         foldRequired: height > 55))
        }
        
        self.reviewData = reviewResult
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
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionViewDelegate

extension MyReviewVC: MyReviewEmptyViewDelegate {
    func myReviewEmptyViewDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension MyReviewVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - CollectionViewDataSource

extension MyReviewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmptyView: Bool = reviewData.count == 0
        if isEmptyView {
            return 1
        } else {
            return reviewData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isEmptyView: Bool = reviewData.count == 0
        if isEmptyView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewEmptyViewCVC.className, for: indexPath) as? MyReviewEmptyViewCVC else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewCVC.className, for: indexPath) as? MyReviewCVC else { return UICollectionViewCell() }
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
            
            cell.layoutEnumValue = setEnumValue(data: reviewData[indexPath.row].data)
            cell.setLayout()
            cell.delegate = self
            return cell
        }
    }
}

extension MyReviewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let isEmptyView: Bool = reviewData.count == 0
        if isEmptyView {
            let cellWidth = width
            let cellHeight = cellWidth * 814/cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellWidth = width
            let cellHeight = calculateReviewCellHeight(containsPhoto: reviewData[indexPath.row].data.reviewImageURLList?.count != 0,
                                                       reviewText: reviewData[indexPath.row].data.reviewContents,
                                                       isExpandState: expendStateList[indexPath.row])
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    private func calculateReviewCellHeight(containsPhoto: Bool, reviewText: String?,isExpandState: Bool) -> CGFloat {
        var cellHeight: CGFloat = 0
        
        let topPadding: CGFloat = 28
        let nameLabelHeight: CGFloat = 20
        let starViewTopPadding: CGFloat = 10
        let starViewHeight: CGFloat = 18
        let tagHeight: CGFloat = 22
        let tagTopPadding: CGFloat = 10
        let tempPadding: CGFloat = 15
        let threeLineHeight: CGFloat = 51
        let bottomPadding: CGFloat = 28
        let imageBottomPadding: CGFloat = 12
        
        cellHeight += topPadding
        cellHeight += nameLabelHeight
        cellHeight += starViewTopPadding
        cellHeight += starViewHeight
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
}

// MARK: - MyReviewCVCDelegate

extension MyReviewVC: MyReviewCVCDelegate {
    
    func restaurantNameTapped(restaurantId: String) {
        let vc = ModuleFactory.resolve().makeMainDetailVC()
        vc.panGestureEnabled = false
        vc.restaurantId = restaurantId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editButtonTapped(reviewId: String, restaurantName: String, score: Double, tagList: [String], content: String, image: [UIImage])  {
        // TODO: - 수정 API 붙이기
        let vc = ModuleFactory.resolve().makeReviewWriteVC()
        vc.isEdited = true
        vc.reviewId = reviewId
        vc.restaurantName = restaurantName
        vc.currentRate = score
        vc.tagList = tagList
        vc.content = content
        vc.userSelectedImages = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteButtonTapped(reviewId: String) {
        // TODO: - 삭제 API 붙이기
        self.makeAlert(alertType: .deleteReviewAlert,
                       title: "작성한 리뷰를 \n 삭제하실건가요?", subtitle: nil) {
            self.requestReviewDelete(reviewId: reviewId) {
                self.requestReviewListWithAPI()
            }
        }
    }
}

extension MyReviewVC {
    private func requestReviewListWithAPI() {
        ReviewService.shared.requestUserReview(userId: UserManager.shared.getUser?.id ?? "") { networkResult in
            switch networkResult {
            case .success(let data):
                print("🙃\(data)")
                self.reviewServerData.removeAll()
                if let data = data as? [MyReviewEntity] {
                    for da in data {
                        self.reviewServerData.append(da.toDomain())
                    }
                    self.processViewModel(self.reviewServerData)
                    self.reviewCV.reloadData()
                }
            case .networkFail:
                print("서버통신 실패")
            default:
                break
            }
        }
    }
    
    func requestReviewDelete(reviewId: String, completion: @escaping(() -> Void)) {
        ReviewService.shared.requestReviewDelete(reviewId: reviewId){ networkResult in
            print(networkResult)
            switch networkResult {
            case .success(let data):
                if let data = data as? String {
                    print(data, "성공")
                    completion()
                }
            default:
                break
            }
        }
    }
}

