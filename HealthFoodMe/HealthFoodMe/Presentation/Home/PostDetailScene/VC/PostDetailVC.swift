////
////  PostDetailVC.swift
////  HealthFoodMe
////
////  Created by Junho Lee on 2022/05/16.
////
//
//import UIKit
//
//import RxSwift
//import RxCocoa
//import SnapKit
//
//final class PostDetailVC: BaseVC {
//    
//    // MARK: - Properties
//    
//    static var storyboard: Storyboards = .postDetail
//    
//    enum SectionType: Int {
//        case imageSection = 0
//        case postSection = 1
//    }
//    
//    var postDetailModel: PostDetail? {
//        didSet {
//            detailCV.reloadData()
//            if let data = postDetailModel {
//                self.pageControl.numberOfPages = min(5, data.image.count)
//                self.pageControl.currentPage = 0
//                bottomView.setData(data: data)
//            }
//        }
//    }
//    
//    var postId: String?
//    var fromPostWrite: Bool = false
//    
//    private lazy var postContentCell = PostContentCVC()
//    
//    private lazy var detailCV: UICollectionView = {
//        let layout = createLayout()
//        layout.configuration.interSectionSpacing = 0
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.showsHorizontalScrollIndicator = false
//        cv.backgroundColor = .carrotWhite
//        return cv
//    }()
//    
//    internal let pageControl: UIPageControl = {
//        let pc = UIPageControl()
//        pc.numberOfPages = 5
//        pc.pageIndicatorTintColor = .carrotDarkLightGray
//        pc.currentPageIndicatorTintColor = .carrotWhite
//        return pc
//    }()
//    
//    private lazy var naviHomeButton: UIButton =  {
//        let bt = UIButton()
//        bt.setImage(ImageLiterals.PostDetail.homeIcon, for: .normal)
//        bt.addAction(UIAction(handler: { _ in
//            self.navigationController?.popViewController(animated: true)
//        }), for: .touchUpInside)
//        bt.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
//        return bt
//    }()
//    
//    private lazy var naviMoreButton: UIButton =  {
//        let bt = UIButton()
//        bt.setImage(ImageLiterals.PostDetail.moreIcon, for: .normal)
//        bt.addAction(UIAction(handler: { _ in
//            
//        }), for: .touchUpInside)
//        bt.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
//        return bt
//    }()
//    
//    private lazy var bottomView = PostDetailBottomView()
//    
//    // MARK: - Life Cycles
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        bind()
//        setDelegate()
//        setCollectionView()
//        
//        getPostDetail()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.tabBarController?.tabBar.isHidden = true
//    }
//    
//    // MARK: - Bind
//    
//    override func bind() {
//        bottomView.likeButtonTapped.throttleOnMain(.seconds(1))
//            .asDriver(onErrorJustReturn: true)
//            .drive(onNext: { [weak self] selected in
//                self?.bottomView.likeButton.isSelected.toggle()
//                self?.changeLikesStatus()
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    // MARK: - Custom Methods
//    
//    private func setDelegate() {
//        detailCV.delegate = self
//        detailCV.dataSource = self
//    }
//    
//    private func setCollectionView() {
//        detailCV.register(PostDetailUserHeader.self, forSupplementaryViewOfKind: PostDetailUserHeader.className, withReuseIdentifier: PostDetailUserHeader.className)
//        
//        PostImageCVC.register(target: detailCV)
//        PostContentCVC.register(target: detailCV)
//    }
//    
//    private func fetchPostDetailData(data: PostDetail) {
//        postContentCell.changeSellStatus(status: "\(data.onSale)")
//    }
//    
//    private func getPostDetail() {
//        if let postId = postId,
//            !fromPostWrite {
//            getPostDetail(postId: postId)
//        }
//    }
//    
//    // MARK: - UI & Layout
//    
//    override func setUI() {
//        view.backgroundColor = .carrotWhite
//        
//        let homeBtn = UIBarButtonItem(customView: naviHomeButton)
//        let moreBtn = UIBarButtonItem(customView: naviMoreButton)
//        self.navigationItem.setLeftBarButton(homeBtn, animated: false)
//        self.navigationItem.setRightBarButton(moreBtn, animated: false)
//        
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    
//    override func setLayout() {
//        view.addSubviews(detailCV, pageControl, bottomView)
//        
//        detailCV.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(bottomView.snp.top)
//        }
//        
//        pageControl.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(UIScreen.main.bounds.width-23)
//        }
//        
//        bottomView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(103)
//        }
//    }
//}
//
//// MARK: Collection DataSource
//
//extension PostDetailVC: UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let sectionType = SectionType(rawValue: section) else { return 1 }
//        
//        switch sectionType {
//        case .imageSection:
//            if let data = postDetailModel {
//                return data.image.count
//            } else { return 5 }
//            
//        case .postSection: return 1
//        }
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == PostDetailUserHeader.className {
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PostDetailUserHeader.className, for: indexPath)
//            if let view = view as? PostDetailUserHeader,
//               let data = postDetailModel {
//                view.setData(data: data)
//            }
//            return view
//        } else { return UICollectionReusableView() }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        guard let sectionType = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
//        
//        switch sectionType {
//        case .imageSection:
//            guard let postImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCVC.className, for: indexPath) as? PostImageCVC else { return UICollectionViewCell() }
//            if let data = postDetailModel {
//                postImageCell.setData(postImageURL: data.image[indexPath.row])
//            } else {
//                postImageCell.setData(postImage: ImageLiterals.PostDetail.sample[indexPath.row])
//            }
//            
//            return postImageCell
//        case .postSection:
//            guard let postContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostContentCVC.className, for: indexPath) as? PostContentCVC else { return UICollectionViewCell() }
//            postContentCell.delegate = self
//            if let data = postDetailModel {
//                postContentCell.setData(data: data)
//            }
//            self.postContentCell = postContentCell
//            
//            return postContentCell
//        }
//    }
//}
//
//// MARK: CollectionView Delegate
//extension PostDetailVC: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.pageControl.snp.remakeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(-scrollView.contentOffset.y+UIScreen.main.bounds.width-40)
//        }
//    }
//}
//
//// MARK: Cell Delegate
//extension PostDetailVC: PostContentDelegate {
//    func presentSellStatusActionSheet() {
//        let actionSheet = UIAlertController(title: "상태 변경", message: nil, preferredStyle: .actionSheet)
//        
//        let sellingAction = UIAlertAction(title: "판매중", style: .default) { _ in
//            self.postContentCell.changeSellStatus(status: "0")
//            self.changeSellStatus(onSale: "0")
//        }
//        let reservedAction = UIAlertAction(title: "예약중", style: .default) { _ in
//            self.postContentCell.changeSellStatus(status: "1")
//            self.changeSellStatus(onSale: "1")
//        }
//        let completedAction = UIAlertAction(title: "거래완료", style: .default) { _ in
//            self.postContentCell.changeSellStatus(status: "2")
//            self.changeSellStatus(onSale: "2")
//        }
//        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
//        
//        actionSheet.addAction(sellingAction)
//        actionSheet.addAction(reservedAction)
//        actionSheet.addAction(completedAction)
//        actionSheet.addAction(cancelAction)
//        
//        self.present(actionSheet, animated: true)
//    }
//}
//
//// MARK: Network
//extension PostDetailVC {
//    func getPostDetail(postId: String) {
//        HomeService.shared.getPostDetail(postId: postId) { networkResult in
//            switch networkResult {
//            case .success(let data):
//                if let data = data as? PostDetail {
//                    self.postDetailModel = data
//                    self.bottomView.setData(data: data)
//                }
//            default:
//                break
//            }
//        }
//    }
//    
//    func changeSellStatus(onSale: String) {
//        HomeService.shared.changeSellStatus(postId: postId ?? "", onSale: onSale) { networkResult in
//            switch networkResult {
//            case .success(let message):
//                print(message)
//            default:
//                break
//            }
//        }
//    }
//    
//    func changeLikesStatus() {
//        HomeService.shared.changeLikeStatus(postId: postId ?? "") { networkResult in
//            switch networkResult {
//            case .success(let message):
//                print(message)
//            default:
//                break
//            }
//        }
//    }
//}
