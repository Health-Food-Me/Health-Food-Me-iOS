//
//  MainMapVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import SnapKit

class MainMapVC: UIViewController, NMFLocationManagerDelegate {
    
    // MARK: - Properties
    private lazy var clLocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    private var isBrowsing: Bool {
        return UserManager.shared.isBrowsing
    }
    private var initialMapOpened: Bool = false
    private let disposeBag = DisposeBag()
    private var isInitialPoint = false
    private var currentZoom: Double = 0
    private var currentRestaurantId: String = ""
    private var currentLocation: Location = Location.init(latitude: 0, longitude: 0)
    private var currentScrapList: [ScrapListEntity] = []
    private var currentCategory: String = "" {
        didSet {
            if currentCategory != "" {
                self.fetchCategoryList(zoom: self.currentZoom)
            } else {
                self.fetchRestaurantList(zoom: self.currentZoom)
            }
        }
    }
    private let locationManager = NMFLocationManager.sharedInstance()
    private var selectedCategories: [Bool] = Array(repeating: false, count: 10) {
        didSet {
            self.unselectMapPoint()
            categoryCollectionView.reloadData()
        }
    }
    private var restaurantData: [MainMapEntity] = []
    private var canUseLocation = false
    var viewModel: MainMapViewModel!
    
    
    // MARK: - UI Components
    
    private lazy var mapView: NaverMapContainerView = {
        let map = NaverMapContainerView()
        return map
    }()
    
    private lazy var hamburgerButton: UIButton =  {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.menuIcon, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            self.makeVibrate()
            self.unselectMapPoint()
            let nextVC = ModuleFactory.resolve().makeHamburgerBarNavigationController()
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: false)
        }), for: .touchUpInside)
        bt.backgroundColor = .helfmeWhite
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 13
        bt.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        return bt
    }()
    
    private var searchBar: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 13
        view.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        return view
    }()
    
    private var searchIconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = ImageLiterals.Map.searchIcon
        return imgView
    }()
    
    private let searchLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Map.Main.searchBar
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 15)
        return lb
    }()
    
    private let manifyingImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = ImageLiterals.Map.manifyingIcon
        return iv
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 32), collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    private lazy var scrapButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.scrapIcon, for: .normal)
        bt.setImage(ImageLiterals.MainDetail.scrapIcon_filled, for: .selected)
        bt.addAction(UIAction(handler: { _ in
            self.makeVibrate()
            if self.isBrowsing {
                let alert = ModuleFactory.resolve().makeHelfmeLoginAlertVC()
                alert.modalPresentationStyle = .overFullScreen
                alert.modalTransitionStyle = .crossDissolve
                alert.loginSuccessClosure = { loginSuccess in
                    if loginSuccess {
                        self.fetchRestaurantList(zoom: 2000)
                    }
                }
                self.present(alert, animated: true)
            } else {
                bt.isSelected.toggle()
                self.filterScrapData()
            }
        }), for: .touchUpInside)
        bt.backgroundColor = .helfmeWhite
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 28
        bt.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        return bt
    }()
    
    private lazy var myLocationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.mylocationIcon, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            if self.canUseLocation {
                self.makeVibrate()
                let NMGPosition = self.locationManager?.currentLatLng()
                if let position = NMGPosition {
                    self.mapView.moveCameraPositionWithZoom(position, 200)
                }
            } else {
                switch self.clLocationManager.authorizationStatus {
                case .denied:
                    self.clLocationManager.requestWhenInUseAuthorization()
                case .notDetermined, .restricted:
                    self.clLocationManager.requestWhenInUseAuthorization()
                default:
                    break
                }
            }
        }), for: .touchUpInside)
        bt.backgroundColor = .helfmeWhite
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 28
        bt.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        return bt
    }()
    
    private lazy var scrapListEmptyToastView: UpperToastView = {
        let toastView = UpperToastView(title: I18N.Map.Main.scrapEmptyGuide)
        toastView.layer.cornerRadius = 20
        return toastView
    }()
    
    private var mapDetailSummaryView = MapDetailSummaryView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTapGesture()
        setDelegate()
        registerCell()
        setPanGesture()
        setMapView()
        addObserver()
        self.bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindMapView()
        setIntitialMapPoint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.disableSelectPoint.accept(())
    }
}

// MARK: - Methods

extension MainMapVC {
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        searchBar.addSubviews(searchIconImageView)
        view.addSubviews(mapView, hamburgerButton, searchBar,
                         categoryCollectionView, mapDetailSummaryView, scrapButton,
                         myLocationButton,scrapListEmptyToastView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        hamburgerButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(55)
            make.height.equalTo(52)
        }
        
        searchBar.snp.makeConstraints { make in
            make.centerY.equalTo(hamburgerButton.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(hamburgerButton.snp.trailing).offset(10)
            make.height.equalTo(52)
        }
        
        searchBar.addSubviews(searchLabel, manifyingImageView)
        
        searchLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        manifyingImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(hamburgerButton.snp.bottom).offset(12)
            make.height.equalTo(32 + 10)
        }
        
        mapDetailSummaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            make.height.equalTo(UIScreen.main.bounds.height + 300)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(myLocationButton.snp.top).offset(-12)
            make.width.height.equalTo(56)
        }
        
        let bottomSafeArea = safeAreaBottomInset()
        myLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset((bottomSafeArea+5) * (-1))
            make.width.height.equalTo(56)
        }
        
        scrapListEmptyToastView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapDetailSummaryView.snp.bottom).offset(200)
        }
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentSearchVC))
        searchBar.addGestureRecognizer(tapGesture)
        
        let tapBottomSheet = UITapGestureRecognizer(target: self, action: #selector(presentDetailVC))
        mapDetailSummaryView.addGestureRecognizer(tapBottomSheet)
    }
    
    private func setDelegate() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        mapDetailSummaryView.delegate = self
    }
    
    private func registerCell() {
        MenuCategoryCVC.register(target: categoryCollectionView)
    }
    
    private func filterScrapData() {
        if scrapButton.isSelected {
            if let userID = UserManager.shared.getUserId {
                UserService.shared.getScrapList(userId: userID) { result in
                    switch(result) {
                    case .success(let entity):
                        
                        if let scrapList = entity as? [ScrapListEntity] {
                            if scrapList.isEmpty { self.showUpperToast() }
                            self.currentScrapList = scrapList
                            if !self.currentCategory.isEmpty {
                                self.fetchCategoryList(zoom: self.currentZoom)
                            } else {
                                self.mapView.scrapButtonSelected.accept(scrapList)
                            }
                        }
                    default : break
                    }
                }
            }
        } else {
            fetchRestaurantList(zoom: self.currentZoom)
        }
    }
    
    private func filterScrapData(_ list:[ScrapListEntity], _ mapList: [MapPointDataModel]) -> [MapPointDataModel] {
        
        var scrapList: [MapPointDataModel] = []
        for scrapPoint in list {
            if let item = mapList.first(where: { mapData in
                return (mapData.latitude == scrapPoint.latitude)
            }) {
                scrapList.append(item)
            }
        }
        return scrapList
    }
    
    private func setPanGesture() {
        let panGesture = UIPanGestureRecognizer()
        mapDetailSummaryView.addGestureRecognizer(panGesture)
        panGesture.rx.event.asDriver { _ in .never() }
            .drive(onNext: { [weak self] sender in
                let summaryViewTranslation = sender.translation(in: self?.mapDetailSummaryView)
                print(self?.mapDetailSummaryView.frame.origin.y ?? 0)
                switch sender.state {
                case .changed:
                    self?.scrapButton.isHidden = true
                    self?.myLocationButton.isHidden = true
                    UIView.animate(withDuration: 0.1) {
                        self?.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: summaryViewTranslation.y)
                    }
                case .ended:
                    guard let self = self else { return }
                    let summaryViewHeight: CGFloat = 189
                    
                    if summaryViewTranslation.y < -90
                        || (self.mapDetailSummaryView.frame.origin.y < 30) {
                        self.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(44)
                        }
                        
                        self.myLocationButton.snp.updateConstraints { make in
                            make.bottom.equalTo(self.mapDetailSummaryView.snp.top).offset((20) * (-1))
                        }
                        
                        UIView.animate(withDuration: 0.3, delay: 0) {
                            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            self.transitionAndPresentMainDetailVC()
                            self.scrapButton.isHidden = true
                            self.myLocationButton.isHidden = false
                        }
                        
                    } else if summaryViewTranslation.y > 15
                                && self.mapDetailSummaryView.frame.origin.y > UIScreen.main.bounds.height - summaryViewHeight {
                        self.mapView.disableSelectPoint.accept(())
                        self.hideMapDetailSummaryView()
                    } else {
                        self.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
                        }
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            self.scrapButton.isHidden = true
                            self.myLocationButton.isHidden = false
                        }
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModels() {
        let input = MainMapViewModel.Input(myLocationButtonTapped: myLocationButton.rx.tap.asObservable(), scrapButtonTapped: scrapButton.rx.tap.asObservable())
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    private func resetUI() {
        navigationController?.isNavigationBarHidden =  true
    }
    
    private func setIntitialMapPoint() {
        if !initialMapOpened {
            initialMapOpened = true
            let NMGPosition = self.locationManager?.currentLatLng()
            if NMGPosition != nil {
                self.mapView.moveCameraPositionWithZoom(LocationLiterals.gangnamStation, 2000)
            }
            isInitialPoint = true
        }
    }
    
    private func setMapView() {
        locationManager?.add(self)
    }
    
    private func unselectMapPoint() {
        self.mapView.disableSelectPoint.accept(())
        hideMapDetailSummaryView()
    }
    
    private func hideMapDetailSummaryView() {
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        let bottomSafeArea = self.safeAreaBottomInset()
        self.myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.mapDetailSummaryView.snp.top).offset((bottomSafeArea+5) * (-1))
        }
        self.myLocationButton.isHidden = false
        self.scrapButton.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindMapView() {
        mapView.rx.mapViewClicked
            .subscribe(onNext: { _ in
                self.unselectMapPoint()
            }).disposed(by: self.disposeBag)
        
        mapView.zoomLevelChange
            .throttleOnMain(.seconds(1))
            .subscribe(onNext: { [weak self] zoomLevel in
                guard let self = self else { return }
                let accumulate = MapAccumulationCalculator.zoomLevelToDistance(level: zoomLevel)
                self.currentZoom = Double(accumulate)
                self.fetchRestaurantList(zoom: Double(accumulate))
            }).disposed(by: self.disposeBag)
        
        mapView.setSelectPoint
            .subscribe(onNext: { [weak self] dataModel in
                let NMGPosition = NMGLatLng(lat: dataModel.latitude,
                                            lng: dataModel.longtitude)
                if let restaurantId = self?.matchRestaurantId(position: NMGPosition) {
                    self?.currentRestaurantId = restaurantId
                    self?.currentLocation = Location(latitude: dataModel.latitude, longitude: dataModel.longtitude)
                    self?.fetchRestaurantSummary(id: restaurantId)
                }
                
                let summaryViewHeight: CGFloat = 189
                self?.mapDetailSummaryView.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
                }
                if let mapDetailViewTopCosntraint = self?.mapDetailSummaryView.snp.top {
                    self?.myLocationButton.snp.updateConstraints { make in
                        make.bottom.equalTo(mapDetailViewTopCosntraint).offset(-12)
                    }
                }
                
                self?.myLocationButton.isHidden = false
                self?.scrapButton.isHidden = true
                
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self?.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func addObserver() {
        addObserverAction(.moveFromHamburgerBar) { noti in
            if let screenCase = noti.object as? HamburgerType {
                self.hamburgerbarVCDidTap(hamburgerType: screenCase)
            }
        }
    }
    
    private func makeCurrentCategory() -> Observable<String> {
        return .create { observer in
            observer.onNext(self.currentCategory)
            return Disposables.create()
        }
    }
    
    private func transitionAndPresentMainDetailVC() {
        let nextVC = ModuleFactory.resolve().makeMainDetailVC()
        nextVC.translationClosure = { scrapChanged in
            self.mapDetailSummaryView.scrapButton.isSelected = scrapChanged
            self.mapDetailSummaryView.isHidden = false
            let summaryViewHeight: CGFloat = 189
            self.mapDetailSummaryView.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.scrapButton.isHidden = true
                self.myLocationButton.isHidden = false
                self.hamburgerButton.isHidden = false
                self.searchBar.isHidden = false
                self.categoryCollectionView.isHidden = false
            }
        }
        nextVC.restaurantId = self.currentRestaurantId
        nextVC.restaurantLocation = self.currentLocation
        if let lat = locationManager?.currentLatLng().lat,
           let lng = locationManager?.currentLatLng().lng {
            nextVC.userLocation = Location(latitude: lat, longitude: lng)
        }
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true) {
            self.mapDetailSummaryView.isHidden = true
            self.hamburgerButton.isHidden = true
            self.searchBar.isHidden = true
            self.categoryCollectionView.isHidden = true
        }
    }
    
    private func setCurrentCategory(currentIndex: Int) {
        if selectedCategories[currentIndex] {
            for (index, item) in selectedCategories.enumerated() {
                if (selectedCategories[index] == true) && (index != currentIndex) {
                    selectedCategories[index] = false
                }
            }
        }
        var hasCurrent: Bool = false
        for (index, item) in selectedCategories.enumerated() {
            if item {
                currentCategory = MainMapCategory.categorySample[index].menuName
                hasCurrent = true
            }
        }
        if !hasCurrent {
            currentCategory = ""
        }
    }
    
    private func matchRestaurantId(position: NMGLatLng) -> String {
        var id = ""
        restaurantData.forEach { entity in
            if entity.latitude == position.lat,
               entity.longitude == position.lng {
                id = entity.id
            }
        }
        return id
    }
    
    @objc
    private func presentSearchVC() {
        self.makeVibrate()
        self.unselectMapPoint()
        let nextVC = ModuleFactory.resolve().makeSearchVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    private func presentDetailVC() {
        self.scrapButton.isHidden = true
        self.myLocationButton.isHidden = true
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(44)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.transitionAndPresentMainDetailVC()
        }
    }
}

// MARK: - CollectionView Delegate

extension MainMapVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        makeVibrate()
        selectedCategories[indexPath.row].toggle()
        setCurrentCategory(currentIndex: indexPath.row)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        selectedCategories[indexPath.row].toggle()
        setCurrentCategory(currentIndex: indexPath.row)
        return true
    }
}

extension MainMapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MainMapCategory.categorySample[indexPath.row].menuName.size(withAttributes: [NSAttributedString.Key.font: UIFont.NotoRegular(size: 14)]).width + 50, height: 32)
    }
}

extension MainMapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainMapCategory.categorySample.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCategoryCVC.className, for: indexPath) as? MenuCategoryCVC else { return UICollectionViewCell() }
        cell.isDietMenu = MainMapCategory.categorySample[indexPath.row].isDietMenu
        cell.setData(data: MainMapCategory.categorySample[indexPath.row])
        cell.isSelected = selectedCategories[indexPath.row]
        return cell
    }
}

extension MainMapVC: HamburgerbarVCDelegate {
    func hamburgerbarVCDidTap(hamburgerType: HamburgerType) {
        switch hamburgerType {
        case .editName:
            navigationController?.pushViewController(ModuleFactory.resolve().makeNicknameChangeVC(), animated: true)
        case .scrap:
            navigationController?.pushViewController(ModuleFactory.resolve().makeScrapVC(), animated: true)
        case .myReview:
            navigationController?.pushViewController(ModuleFactory.resolve().makeMyReviewVC(), animated: true)
        case .setting:
            navigationController?.pushViewController(ModuleFactory.resolve().makeSettingVC(), animated: true)
        }
    }
}

extension MainMapVC: MapDetailSummaryViewDelegate {
    func MapDetailSummaryViewScarp(isBrowsing: Bool) {
        if isBrowsing {
            let alert = ModuleFactory.resolve().makeHelfmeLoginAlertVC()
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            alert.loginSuccessClosure = { loginSuccess in
                
            }
            self.present(alert, animated: true)
        } else {
            putScrap(userId: UserManager.shared.getUserId ?? "", restaurantId: currentRestaurantId)
        }
    }
}

// MARK: - Network

extension MainMapVC {
    
    private func makePoints(points: [MapPointDataModel]) -> Observable<[MapPointDataModel]> {
        return .create { observer in
            observer.onNext(points)
            return Disposables.create()
        }
    }
    
    private func fetchRestaurantList(zoom: Double) {
        if canUseLocation {
            if let lng = locationManager?.currentLatLng().lng,
               let lat = locationManager?.currentLatLng().lat {
                
                if currentCategory.isEmpty {
                    currentCategory = MainMapCategory.allCategoryString
                }
                
                RestaurantService.shared.fetchRestaurantList(longitude: lat, latitude: lng, zoom: zoom, category: currentCategory) { networkResult in
                    switch networkResult {
                    case .success(let data):
                        if let data = data as? [MainMapEntity] {
                            self.restaurantData = data
                            var models = [MapPointDataModel]()
                            
                            models = data.map({ entity in
                                entity.toDomainWithCaption()
                            })
                            if self.scrapButton.isSelected {
                                self.mapView.scrapButtonSelected.accept(self.currentScrapList)
                            } else {
                                self.makePoints(points: models).bind(to: self.mapView.rx.pointList)
                                    .disposed(by: self.disposeBag)
                            }
                            
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func fetchCategoryList(zoom: Double) {
        if canUseLocation {
            if let lng = locationManager?.currentLatLng().lng,
               let lat = locationManager?.currentLatLng().lat {
                RestaurantService.shared.fetchRestaurantList(longitude: lat, latitude: lng, zoom: zoom, category: currentCategory) { networkResult in
                    switch networkResult {
                    case .success(let data):
                        if let data = data as? [MainMapEntity] {
                            self.restaurantData = data
                            var models = [MapPointDataModel]()
                            models = data.map({ entity in
                                entity.toDomainWithCaption()
                            })
                            if self.scrapButton.isSelected {
                                var filterList: [ScrapListEntity] = []
                                for model in models {
                                    if let item = self.currentScrapList.first(where: { $0.longtitude == model.longtitude } ){
                                        filterList.append(item)
                                    }
                                }
                                
                                self.mapView.scrapButtonSelected.accept(filterList)
                            } else {
                                self.makePoints(points: models).bind(to: self.mapView.rx.categoryPointList)
                                    .disposed(by: self.disposeBag)
                            }
                            
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func fetchRestaurantSummary(id: String) {
        RestaurantService.shared.fetchRestaurantSummary(restaurantId: id, userId: UserManager.shared.getUserId ?? "browsing") { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? RestaurantSummaryEntity {
                    self.mapDetailSummaryView.setData(data: data)
                }
            default:
                break
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

extension MainMapVC {
    private func showUpperToast() {
        makeVibrate()
        scrapListEmptyToastView.snp.remakeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
        UIView.animate(withDuration: 0.7, delay: 0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.hideUpperToast()
            }
        }
    }
    
    private func hideUpperToast() {
        scrapListEmptyToastView.snp.remakeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapDetailSummaryView.snp.bottom).offset(200)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func checkLocationStatus() {
        switch clLocationManager.authorizationStatus {
        case .authorizedAlways:
            canUseLocation = true
        case .authorizedWhenInUse:
            canUseLocation = true
        default:
            break
        }
    }
}

extension MainMapVC: CLLocationManagerDelegate {
    func locationManager(_ locationManager: NMFLocationManager!, didChangeAuthStatus status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.mapView.naverMapView.mapView.positionMode = .normal
                self.canUseLocation = true
                self.fetchRestaurantList(zoom: 2000)
            }
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.mapView.naverMapView.mapView.positionMode = .normal
                self.canUseLocation = true
                self.fetchRestaurantList(zoom: 2000)
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidStartLocationUpdates(_ locationManager: NMFLocationManager!) {
        self.canUseLocation = true
    }
}
