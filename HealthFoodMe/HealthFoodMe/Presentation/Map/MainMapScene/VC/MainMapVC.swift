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
    
    private let disposeBag = DisposeBag()
    private var isInitialPoint = false
    private let locationManager = NMFLocationManager.sharedInstance()
    private var selectedCategories: [Bool] = [false, false, false,
                                              false, false, false,
                                              false, false] {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
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
            let nextVC = ModuleFactory.resolve().makeHamburgerBarVC()
            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.delegate = self
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
            bt.isSelected.toggle()
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
            self.makeVibrate()
            let NMGPosition = self.locationManager?.currentLatLng()
            if let position = NMGPosition {
              self.mapView.moveCameraPositionWithZoom(position, 200)
            }
        }), for: .touchUpInside)
        bt.backgroundColor = .helfmeWhite
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 28
        bt.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        return bt
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
        bindMapView()
        sampleViewInputEvent()
        self.bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        searchBar.addSubview(searchIconImageView)
        view.addSubviews(mapView, hamburgerButton, searchBar,
                         categoryCollectionView, mapDetailSummaryView, scrapButton,
                         myLocationButton)
        
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
    }
    
    private func registerCell() {
        MenuCategoryCVC.register(target: categoryCollectionView)
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
                    if summaryViewTranslation.y < -90
                        || (self.mapDetailSummaryView.frame.origin.y ?? 40 < 30) {
                        self.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(44)
                        }
                        
                        let bottomSafeArea = self.safeAreaBottomInset()
                        self.myLocationButton.snp.updateConstraints { make in
                            make.bottom.equalTo(self.mapDetailSummaryView.snp.top).offset((bottomSafeArea+20) * (-1))
                        }
                        
                        UIView.animate(withDuration: 0.3, delay: 0) {
                            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            self.transitionAndPresentMainDetailVC()
                        }
                        
                    } else {
                        let summaryViewHeight: CGFloat = 189
                        self.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
                        }
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            self.scrapButton.isHidden = false
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
            
            let NMGPosition = self.locationManager?.currentLatLng()
            if let position = NMGPosition {
                self.mapView.moveCameraPositionWithZoom(position, 2000)
            } else {
                self.mapView.moveCameraPositionWithZoom(LocationLiterals.gangnamStation, 2000)
            }
            isInitialPoint = true

    }
    
    private func setMapView() {
        locationManager?.add(self)
    }
    
    private func unselectMapPoint() {
        self.mapView.disableSelectPoint.accept(())
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        let bottomSafeArea = self.safeAreaBottomInset()
        self.myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.mapDetailSummaryView.snp.top).offset((bottomSafeArea+5) * (-1))
        }
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
        .subscribe(onNext: { [weak self] zoomLevel in
          guard let self = self else { return }
            let accumulate = MapAccumulationCalculator.zoomLevelToDistance(level: zoomLevel)
            print(accumulate)
        }).disposed(by: self.disposeBag)
              
        mapView.setSelectPoint
            .subscribe(onNext: { [weak self] dataModel in
                let summaryViewHeight: CGFloat = 189
                self?.mapDetailSummaryView.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
                }
                if let mapDetailViewTopCosntraint = self?.mapDetailSummaryView.snp.top {
                    self?.myLocationButton.snp.updateConstraints { make in
                        make.bottom.equalTo(mapDetailViewTopCosntraint).offset(-12)
                    }
                }

                UIView.animate(withDuration: 0.3, delay: 0) {
                    self?.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func sampleViewInputEvent() {
        makeDummyPoints()
            .bind(to: mapView.rx.pointList)
            .disposed(by: self.disposeBag)
    }
    
    private func makeDummyPoints() -> Observable<[MapPointDataModel]> {
        return .create { observer in
            let pointList: [MapPointDataModel] = .init([
                MapPointDataModel.init(latitude: 37.5666805, longtitude: 126.9784147, type: .normalFood),
                MapPointDataModel.init(latitude: 37.567, longtitude: 126.9784147, type: .healthFood),
                MapPointDataModel.init(latitude: 37.568, longtitude: 126.9784147, type: .normalFood),
                MapPointDataModel.init(latitude: 37.569, longtitude: 126.9784147, type: .normalFood),
                MapPointDataModel.init(latitude: 37.557, longtitude: 126.9784147, type: .healthFood),
                MapPointDataModel.init(latitude: 37.571, longtitude: 126.9784147, type: .normalFood),
                MapPointDataModel.init(latitude: 37.572, longtitude: 126.9784147, type: .normalFood),
                MapPointDataModel.init(latitude: 37.010, longtitude: 126.9784147, type: .normalFood)
            ])
            observer.onNext(pointList)
            return Disposables.create()
        }
    }
    
    private func transitionAndPresentMainDetailVC() {
        let nextVC = ModuleFactory.resolve().makeMainDetailVC()
        nextVC.translationClosure = {
            self.mapDetailSummaryView.isHidden = false
            let summaryViewHeight: CGFloat = 189
            self.mapDetailSummaryView.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.scrapButton.isHidden = false
                self.myLocationButton.isHidden = false
                self.hamburgerButton.isHidden = false
                self.searchBar.isHidden = false
                self.categoryCollectionView.isHidden = false
            }
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
    
    @objc
    private func presentSearchVC() {
        self.mapView.disableSelectPoint.accept(())
        self.makeVibrate()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        makeVibrate()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedCategories[indexPath.row].toggle()
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
    func HamburgerbarVCDidTap(hamburgerType: HamburgerType) {
        switch hamburgerType {
        case .editName:
            navigationController?.pushViewController(ModuleFactory.resolve().makeNicknameChangeVC(), animated: true)
        case .scrap:
            navigationController?.pushViewController(ModuleFactory.resolve().makeScrapVC(), animated: true)
        case .myReview:
            navigationController?.pushViewController(ModuleFactory.resolve().makeScrapVC(), animated: true)
        case .setting:
            navigationController?.pushViewController(ModuleFactory.resolve().makeSettingVC(), animated: true)
        }
    }
}
