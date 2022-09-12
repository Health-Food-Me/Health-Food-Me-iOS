//
//  MainDetailVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

protocol SwipeDismissDelegate {
    func swipeToDismiss()
}

class MainDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var mainInfoTVC = MainInfoTVC()
    private var detailTabTVC = DetailTabTVC()
    private var detailTabTitleHeader = DetailTabTitleHeader()
    private var menuTabVC = ModuleFactory.resolve().makeMenuTabVC()
    private var copingTabVC = ModuleFactory.resolve().makeCopingTabVC()
    private var reviewTabVC = ModuleFactory.resolve().makeReviewDetailVC()
    private var menuCase: TabMenuCase = .menu
    private var phoneMenuTouched: Bool = false
    private var navigationTitle: String = ""
    private var isOpenned: Bool = false
    private var mainInfoInitialReload: Bool = true
    private var isBrowsing: Bool {
        return UserManager.shared.isBrowsing
    }
    var userLocation: Location? = {
        let loc = Location(latitude: 37.49, longitude: 127.02)
        return loc
    }()
    var restaurantId: String = ""
    var restaurantName: String = ""
    var restaurantLocation: Location?
    var panGestureEnabled = true
    var viewModel: MainDetailViewModel!
    var translationClosure: ((Bool) -> Void)?
    var isInitialLoad = true
    var scrapButtonInstance = UIButton()
    
    // MARK: - UI Components
    
    private lazy var mainTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.clipsToBounds = true
        tv.sectionFooterHeight = 0
        tv.allowsSelection = false
        tv.bounces = false
        if #available(iOS 15, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private var reviewWriteCTAButton: CTAButton = {
        let button = CTAButton(enableState: true, title: I18N.Detail.Main.reviewWriteCTATitle)
        var isEdited = false
        button.isEnabled = true
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCell()
        setDelegate()
        bindViewModels()
        setButtonAction()
        fetchRestauranDetail(restaurantId: self.restaurantId) {
            self.isInitialLoad = false
            self.requestReviewEnabled(restaurantId: self.restaurantId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialLoad {
            self.requestReviewEnabled(restaurantId: self.restaurantId)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPanGesture()
    }
}

// MARK: - Methods

extension MainDetailVC {
    
    private func setUI() {
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        view.backgroundColor = .white
        
        let backButton = UIButton()
        backButton.setImage(ImageLiterals.MainDetail.beforeIcon, for: .normal)
        backButton.tintColor = .helfmeBlack
        backButton.addAction(UIAction(handler: { _ in
            if self.panGestureEnabled {
                self.dismiss(animated: false) {
                    self.translationClosure?(self.scrapButtonInstance.isSelected)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }), for: .touchUpInside)
        
        let scrapButton = UIButton()
        scrapButton.setImage(ImageLiterals.MainDetail.scrapIcon, for: .normal)
        scrapButton.setImage(ImageLiterals.MainDetail.scrapIcon_filled, for: .selected)
        scrapButton.addAction(UIAction(handler: { _ in
            scrapButton.isSelected.toggle()
            self.putScrap(userId: UserManager.shared.getUserId ?? "", restaurantId: self.restaurantId)
        }), for: .touchUpInside)
        scrapButtonInstance = scrapButton
        
        reviewWriteCTAButton.layer.cornerRadius = 20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scrapButton)
    }
    
    private func setNavigationTitle(isShown: Bool) {
        self.navigationItem.title = isShown ? navigationTitle : ""
    }
    
    private func setLayout() {
        bottomView.addSubviews(reviewWriteCTAButton)
        view.addSubviews(mainTableView,bottomView)
        let bottomSafeArea = safeAreaBottomInset()
        
        if UIDevice.current.hasNotch {
            reviewWriteCTAButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(40)
            }
        } else {
            reviewWriteCTAButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-21)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(40)
            }
        }
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(bottomSafeArea + 48)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        MainInfoTVC.register(target: mainTableView)
        DetailTabTVC.register(target: mainTableView)
        DetailTabTitleHeader.register(target: mainTableView)
    }
    
    private func setDelegate() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    private func setButtonAction() {
        reviewWriteCTAButton.press {
            if self.isBrowsing {
                let alert = ModuleFactory.resolve().makeHelfmeLoginAlertVC()
                alert.modalPresentationStyle = .overFullScreen
                alert.modalTransitionStyle = .crossDissolve
                alert.loginSuccessClosure = { loginSuccess in
                    if loginSuccess {
                        self.fetchRestauranDetail(restaurantId: self.restaurantId) {
                            self.isInitialLoad = false
                            self.requestReviewEnabled(restaurantId: self.restaurantId)
                        }
                    }
                }
                self.present(alert, animated: true)
            } else {
                let writeVC = ModuleFactory.resolve().makeReviewWriteNavigationController(restaurantId: self.restaurantId, restaurantName: self.restaurantName)
                writeVC.modalPresentationStyle = .fullScreen
                self.present(writeVC, animated: true)
            }
        }
    }
    
    private func bindViewModels() {
        let input = MainDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    private func setPanGesture() {
        let panGesture = UIPanGestureRecognizer()
        if panGestureEnabled {
            mainInfoTVC.addGestureRecognizer(panGesture)
            panGesture.rx.event.asDriver { _ in .never() }
                .drive(onNext: { [weak self] sender in
                    let windowTranslation = sender.translation(in: self?.view)
                    print(windowTranslation)
                    switch sender.state {
                    case .changed:
                        UIView.animate(withDuration: 0.1) {
                            if windowTranslation.y > 0 {
                                self?.view.transform = CGAffineTransform(translationX: 0, y: windowTranslation.y)
                            }
                        }
                    case .ended:
                        if windowTranslation.y > 130 {
                            self?.dismiss(animated: false) {
                                if let scrapChanged = self?.scrapButtonInstance.isSelected {
                                    self?.translationClosure?(scrapChanged)
                                }
                            }
                        } else {
                            self?.view.snp.updateConstraints { make in
                                make.edges.equalToSuperview()
                            }
                            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                                self?.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                self?.view.layoutIfNeeded()
                            }
                        }
                    default:
                        break
                    }
                }).disposed(by: disposeBag)
        }
    }
}

// MARK: TableViewDelegate

extension MainDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return UIScreen.main.bounds.height - 104
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1,
              let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailTabTitleHeader.className) as? DetailTabTitleHeader else { return nil }
        headerCell.titleButtonTapped.asDriver(onErrorJustReturn: 0)
            .drive { selectedIndex in
                self.detailTabTVC.scrollToSelectedIndex(index: selectedIndex)
            }.disposed(by: headerCell.disposeBag)
        detailTabTitleHeader = headerCell
        return headerCell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeaderHeight = mainTableView.rowHeight
        
        if scrollView.contentOffset.y <= scrollHeaderHeight {
            if scrollView.contentOffset.y >= 0 {
                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: -(scrollHeaderHeight+1), left: 0, bottom: 0, right: 0)
        }
    }
}

// MARK: TableViewDataSource

extension MainDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainInfoTVC.className, for: indexPath) as? MainInfoTVC else { return UITableViewCell() }
            cell.toggleButtonTapped.asDriver(onErrorJustReturn: ())
                .drive(onNext: {
                    self.mainInfoInitialReload = false
                    //                    self.isOpenned.toggle()
                    self.mainTableView.reloadData()
                }).disposed(by: disposeBag)
            cell.directionButtonTapped.asDriver(onErrorJustReturn: ())
                .drive(onNext: {
                    self.presentFindDirectionSheet()
                }).disposed(by: disposeBag)
            cell.telePhoneLabelTapped
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { [weak self] phoneNumber in
                    guard let self = self else { return }
                    if !self.phoneMenuTouched {
                        self.phoneMenuTouched = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.phoneMenuTouched = false
                        }
                        URLSchemeManager.shared.loadTelephoneApp(phoneNumber: phoneNumber)
                    }
                }).disposed(by: disposeBag)
            mainInfoTVC = cell
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTabTVC.className, for: indexPath) as? DetailTabTVC else { return UITableViewCell() }
            detailTabTVC = cell
            
            menuTabVC.delegate = self
            menuTabVC.swipeDismissDelegate = self
            copingTabVC.delegate = self
            copingTabVC.panDelegate = self
            copingTabVC.swipeDelegate = self
            reviewTabVC.delegate = self
            reviewTabVC.swipeDismissDelegate = self
            
            copingTabVC.restaurantId = self.restaurantId
            reviewTabVC.restaurantId = self.restaurantId
            
            self.addChild(menuTabVC)
            self.addChild(copingTabVC)
            self.addChild(reviewTabVC)
            cell.receiveChildVC(childVC: menuTabVC)
            cell.receiveChildVC(childVC: copingTabVC)
            cell.receiveChildVC(childVC: reviewTabVC)
            cell.scrollRatio.asDriver(onErrorJustReturn: 0)
                .drive { ratio in
                    if ratio < 1/3{
                        self.menuCase = .menu
                        self.menuTabVC.topScrollAnimationNotFinished = true
                    } else if ratio < 2/3 {
                        self.menuCase = .coping
                        self.copingTabVC.topScrollAnimationNotFinished = true
                    } else {
                        self.menuCase = .review
                        self.reviewTabVC.topScrollAnimationNotFinished = true
                    }
                    
                    if ratio == 0 {
                        self.detailTabTitleHeader.setSelectedButton(buttonIndex: 0)
                    } else if ratio == 1/3 {
                        self.detailTabTitleHeader.setSelectedButton(buttonIndex: 1)
                    } else if ratio == 2/3 {
                        self.detailTabTitleHeader.setSelectedButton(buttonIndex: 2)
                    }
                    self.bottomView.isHidden = !(ratio == 2/3)
                    
                    self.detailTabTitleHeader.moveWithContinuousRatio(ratio: ratio)
                }.disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func presentFindDirectionSheet() {
        let actionSheet = UIAlertController(title: "길 찾기", message: nil, preferredStyle: .actionSheet)
        
        let kakaoAction = UIAlertAction(title: "카카오맵", style: UIAlertAction.Style.default, handler: { _ in
            if let myLocation = self.userLocation,
               let destination = self.restaurantLocation {
                URLSchemeManager.shared.loadKakaoMapApp(myLocation: NameLocation(latitude: myLocation.latitude, longtitude: myLocation.longitude, name: "현위치"), destination: NameLocation(latitude: destination.latitude, longtitude: destination.longitude, name: "올림픽공원"))
            }
        })
        
        let naverAction = UIAlertAction(title: "네이버지도", style: UIAlertAction.Style.default, handler: { _ in
            if let myLocation = self.userLocation,
               let destination = self.restaurantLocation {
                URLSchemeManager.shared.loadNaverMapApp(myLocation: NameLocation(latitude: myLocation.latitude, longtitude: myLocation.longitude, name: "현위치"), destination: NameLocation(latitude: destination.latitude, longtitude: destination.longitude, name: self.restaurantName))
            }
        })
        
        let appleAction = UIAlertAction(title: "Apple Maps", style: UIAlertAction.Style.default, handler: { _ in
            if let destination = self.restaurantLocation {
                URLSchemeManager.shared.loadAppleMapApp(location: Location.init(latitude: destination.latitude, longitude: destination.longitude))
            }
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        actionSheet.addAction(kakaoAction)
        actionSheet.addAction(naverAction)
        actionSheet.addAction(appleAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
}

extension MainDetailVC: ScrollDeliveryDelegate {
    func currentTabMenu(_ type: TabMenuCase) {
        self.menuCase = type
    }
    
    func childViewScrollDidEnd(type: TabMenuCase) {
        self.mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        setNavigationTitle(isShown: false)
        switch(type) {
        case .menu:     menuTabVC.topScrollAnimationNotFinished = true
        case .coping:   copingTabVC.topScrollAnimationNotFinished = true
        case .review:
            reviewTabVC.topScrollAnimationNotFinished = true
        }
    }
    
    func scrollStarted(velocity: CGFloat, scrollView: UIScrollView) {
        if velocity < 0 {
            self.mainTableView.scrollToRow(at: IndexPath.init(row: 0, section: 1), at: .top, animated: true)
            setNavigationTitle(isShown: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 10 {
            switch(menuCase) {
            case .menu: menuTabVC.topScrollAnimationNotFinished = true
            case .coping: copingTabVC.topScrollAnimationNotFinished = true
            case .review: reviewTabVC.topScrollAnimationNotFinished = true
            }
        }
        
        if scrollView.contentOffset.y > 50 {
            switch(menuCase) {
            case .menu: menuTabVC.topScrollAnimationNotFinished = false
            case .coping: copingTabVC.topScrollAnimationNotFinished = false
            case .review: reviewTabVC.topScrollAnimationNotFinished = false
            }
        }
    }
}

extension MainDetailVC: CopingGestureDelegate {
    func downPanGestureSwipe(panGesture: ControlEvent<UIPanGestureRecognizer>.Element) {
        if panGestureEnabled {
            panGesture.rx.event.asDriver { _ in .never() }
                .drive(onNext: { [weak self] sender in
                    
                    let windowTranslation = sender.translation(in: self?.view)
                    switch sender.state {
                    case .changed:
                        self?.mainTableView.isScrollEnabled = false
                        if self?.mainTableView.contentOffset.y == 0 {
                            UIView.animate(withDuration: 0.1) {
                                if windowTranslation.y > 0 {
                                    self?.view.transform = CGAffineTransform(translationX: 0, y: windowTranslation.y)
                                }
                            }
                        }
                        
                    case .ended:
                        self?.mainTableView.isScrollEnabled = true
                        if windowTranslation.y > 130 &&
                            self?.mainTableView.contentOffset.y ?? 0 < 30 {
                            self?.dismiss(animated: false) {
                                if let scrapChanged = self?.scrapButtonInstance.isSelected {
                                    self?.translationClosure?(scrapChanged)
                                }
                            }
                        } else {
                            self?.view.snp.updateConstraints { make in
                                make.edges.equalToSuperview()
                            }
                            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                                self?.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                self?.view.layoutIfNeeded()
                            }
                        }
                    default:
                        break
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func panGestureSwipe(isRight: Bool) {
        let index = isRight ? 2 : 0
        detailTabTVC.containerCollectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredVertically, animated: true)
    }
}

extension MainDetailVC: SwipeDismissDelegate {
    func swipeToDismiss() {
        if panGestureEnabled {
            if mainTableView.contentOffset.y == 0 {
                self.dismiss(animated: false) {
                    self.translationClosure?(self.scrapButtonInstance.isSelected)
                }
            }
        }
    }
}

// MARK: - Network

extension MainDetailVC {
    func fetchRestauranDetail(restaurantId: String, comletion: @escaping(() -> Void)) {
        if let location = userLocation {
            RestaurantService.shared.fetchRestaurantDetail(restaurantId: restaurantId, userId: UserManager.shared.getUserId ?? "browsing", latitude: location.latitude, longitude: location.longitude) { networkResult in
                switch networkResult {
                case .success(let data):
                    if let data = data as? MainDetailEntity {
                        self.navigationTitle = data.restaurant.name
                        self.restaurantName = data.restaurant.name
                        self.mainInfoTVC.isInitialReload = self.mainInfoInitialReload
                        self.mainInfoTVC.setData(data: data)
                        self.menuTabVC.setData(data: data.menu)
                        self.reviewTabVC.restaurantName = data.restaurant.name
                        self.restaurantName = data.restaurant.name
                        self.scrapButtonInstance.isSelected = data.restaurant.isScrap
                    }
                default:
                    print("통신 에러")
                }
            }
        }
        comletion()
    }
    
    func requestReviewEnabled(restaurantId: String) {
        guard !isBrowsing else { return }
        
        ReviewService.shared.requestReviewEnabled(userId: UserManager.shared.getUserId ?? "", restaurantId: restaurantId) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? ReviewCheckEntity {
                    self.checkCTAButtonStatus(hasReview: data.hasReview)
                }
            default:
                print("통신 에러")
            }
        }
    }
    
    private func checkCTAButtonStatus(hasReview: Bool) {
        if hasReview {
            DispatchQueue.main.async {
                self.reviewWriteCTAButton.isEnabled = false
                self.reviewWriteCTAButton.setAttributedTitleForDisabled(title: "리뷰 작성 완료")
            }
        }
    }
    
    private func putScrap(userId: String, restaurantId: String) {
        UserService.shared.putScrap(userId: userId, restaurantId: restaurantId) { networkResult in
            switch networkResult {
            case .success(let message):
                print(message)
            default:
                break;
            }
        }
    }
}
