//
//  SupplementMapVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import SnapKit
import RealmSwift

protocol SupplementMapVCDelegate: AnyObject {
    func supplementMapClicked()
    func supplementMapMarkerClicked()
}

class SupplementMapVC: UIViewController, NMFLocationManagerDelegate {
    
    // MARK: - Properties
    
    enum SupplementMapType {
        case scrap
        case search
    }
    private let disposeBag = DisposeBag()
    private let locationManager = NMFLocationManager.sharedInstance()
    private var currentRestaurantId: String = ""
    private var currentLocation: Location = Location.init(latitude: 0, longitude: 0)
    private var currentSelectedPosition: MapPointDataModel?
    private var restaurantData: [MainMapEntity] = []
    private var isInitialPoint = false
    weak var delegate: SupplementMapVCDelegate?
    var initialPoint: MapPointDataModel?
    var initialId: String?
    var IDsForMap: [String] = []
    var mapType = SupplementMapType.scrap
    var targetMarkerPointList: [MapPointDataModel] = []
    
    // MARK: - UI Components
    
    private let statusTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var customNavigationBar: HelfmeNaviBar = {
        let view = HelfmeNaviBar()
        view.buttonClosure = {
            self.popViewController()
        }
        return view
    }()
    
    private lazy var mapView: NaverMapContainerView = {
        let map = NaverMapContainerView()
        return map
    }()
    
    private lazy var myLocationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.mylocationIcon, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let NMGPosition = self.locationManager?.currentLatLng()
            if let position = NMGPosition {
                self.mapView.moveCameraPosition(position)
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
    
    init(mapType: SupplementMapType) {
        super.init(nibName: nil, bundle: nil)
        self.mapType = mapType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setMapView()
        bindMapView()
        setPanGesture()
        setInitialMarker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Methods

extension SupplementMapVC {
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        view.addSubviews(mapView, mapDetailSummaryView, myLocationButton,
                         statusTopView, customNavigationBar)
        print("4")
        statusTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(customNavigationBar.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapDetailSummaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
            make.height.equalTo(UIScreen.main.bounds.height + 300)
        }
        
        let bottomSafeArea = safeAreaBottomInset()
        myLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset((bottomSafeArea+5) * (-1))
            make.width.height.equalTo(56)
        }
    }
    
    func setInitialMapPoint() {
        
        switch mapType {
        case .search:
            print(initialId, "체크")
            if let id = initialId {
                self.bindSetSelectPointForSearchVC(id: id)
            } else {
                self.mapView.moveCameraPositionWithZoom(LocationLiterals.gangnamStation, 200)
            }
            isInitialPoint = true
        case .scrap:
            if let initial = self.initialPoint {
                let position = NMGLatLng.init(lat: initial.latitude, lng: initial.longtitude)
                self.mapView.moveCameraPositionWithZoom(position, 200)
                self.bindSetSelectPointForScrapVC(dataModel: initial)
                self.restaurantData.forEach { entity in
                    if entity.latitude == initial.latitude, entity.longitude == initial.longtitude {
                        self.mapView.setSelectPoint.accept(entity.toDomain())
                    }
                }
            } else {
                self.mapView.moveCameraPositionWithZoom(LocationLiterals.gangnamStation, 200)
            }
            isInitialPoint = true
        }
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
                    self?.myLocationButton.isHidden = true
                    UIView.animate(withDuration: 0.1) {
                        self?.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: summaryViewTranslation.y)
                    }
                case .ended:
                    if summaryViewTranslation.y < -90
                        || (self?.mapDetailSummaryView.frame.origin.y ?? 40 < 30) {
                        self?.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(66)
                        }
                        
                        UIView.animate(withDuration: 0.3, delay: 0) {
                            self?.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self?.view.layoutIfNeeded()
                        } completion: { _ in
                            self?.transitionAndPresentMainDetailVC()
                        }
                        
                    } else {
                        let summaryViewHeight: CGFloat = 189
                        self?.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
                        }
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                            self?.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                            self?.view.layoutIfNeeded()
                        } completion: { _ in
                            self?.myLocationButton.isHidden = false
                        }
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    private func setMapView() {
        locationManager?.add(self)
    }
    
    private func bindMapView() {
        mapView.rx.mapViewClicked
            .subscribe(onNext: { _ in
                switch self.mapType {
                case .search:
                    self.bindMapViewClickedForSearchVC()
                case .scrap:
                    self.bindMapViewClickedForScrapVC()
                }
            }).disposed(by: self.disposeBag)
        
        mapView.setSelectPoint
            .subscribe(onNext: { [weak self] dataModel in
                guard let self = self else { return }
                switch self.mapType {
                case .search:
                    self.bindSetSelectPointForSearchVC(dataModel: dataModel)
                case .scrap:
                    self.bindSetSelectPointForScrapVC(dataModel: dataModel)
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func bindMapViewClickedForSearchVC() {
        self.mapView.disableSelectPoint.accept(())
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        
        self.myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.mapDetailSummaryView.snp.top).offset(-165)
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.myLocationButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.supplementMapClicked()
        }
    }
    
    private func bindMapViewClickedForScrapVC() {
        self.mapView.disableSelectPoint.accept(())
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        
        self.myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.mapDetailSummaryView.snp.top).offset(-165)
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    private func makePoints(points: [MapPointDataModel]) -> Observable<[MapPointDataModel]> {
        return .create { observer in
            observer.onNext(points)
            return Disposables.create()
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
    
    private func bindSetSelectPointForSearchVC(id: String) {
        delegate?.supplementMapMarkerClicked()
        self.currentRestaurantId = id
        self.fetchRestaurantSummary(id: id)
        
        var targetPosition: MapPointDataModel?
        restaurantData.forEach { entity in
            if entity.id == id {
                targetPosition = entity.toDomain()
                self.mapView.setSelectPoint.accept(entity.toDomain())
            }
        }
        
        if let position = targetPosition {
            let NMGPosition = NMGLatLng.init(lat: position.latitude, lng: position.longtitude)
            self.mapView.moveCameraPositionWithZoom(NMGPosition, 200)
            self.currentLocation = Location(latitude: position.latitude, longitude: position.longtitude)
            currentSelectedPosition = position
        } else {
            self.mapView.moveCameraPositionWithZoom(LocationLiterals.gangnamStation, 200)
            self.currentLocation = Location(latitude: LocationLiterals.gangnamStation.lat, longitude: LocationLiterals.gangnamStation.lng)
        }
        
        myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset(-12)
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.myLocationButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindSetSelectPointForSearchVC(dataModel: MapPointDataModel) {
        delegate?.supplementMapMarkerClicked()
        let NMGPosition = NMGLatLng(lat: dataModel.latitude,
                                    lng: dataModel.longtitude)
        let restaurantId = self.matchRestaurantId(position: NMGPosition)
        self.currentRestaurantId = restaurantId
        self.currentLocation = Location(latitude: dataModel.latitude, longitude: dataModel.longtitude)
        self.fetchRestaurantSummary(id: restaurantId)
        currentSelectedPosition = dataModel
        myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset(-12)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.myLocationButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindSetSelectPointForScrapVC(dataModel: MapPointDataModel) {
        let NMGPosition = NMGLatLng(lat: dataModel.latitude,
                                    lng: dataModel.longtitude)
        let restaurantId = self.matchRestaurantId(position: NMGPosition)
        currentSelectedPosition = dataModel
        self.currentRestaurantId = restaurantId
        self.currentLocation = Location(latitude: dataModel.latitude, longitude: dataModel.longtitude)
        self.fetchRestaurantSummary(id: restaurantId)
        
        showSummaryView()
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
                self.myLocationButton.isHidden = false
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
        }
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setSupplementMapType(mapType: SupplementMapType) {
        switch mapType {
        case .scrap:
            break
        case .search:
            removeCustomNaviBar()
            updateConstraints()
        }
    }
    
    private func removeCustomNaviBar() {
        [statusTopView, customNavigationBar].forEach { view in
            view.isHidden = true
        }
    }
    
    private func updateConstraints() {
        myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset(-166)
        }
    }
    
    func showSummaryView() {
        let summaryViewHeight: CGFloat = 189
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
        }
        
        let mapDetailViewTopCosntraint = self.mapDetailSummaryView.snp.top
        self.myLocationButton.snp.updateConstraints { make in
                make.bottom.equalTo(mapDetailViewTopCosntraint).offset(-12)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    func showSummaryViewForResult() {
        let summaryViewHeight: CGFloat = 189
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
        }
        
        let mapDetailViewTopCosntraint = self.mapDetailSummaryView.snp.top
        self.myLocationButton.snp.updateConstraints { make in
                make.bottom.equalTo(mapDetailViewTopCosntraint).offset(-12)
        }
        if let position = self.currentSelectedPosition {
            mapView.setSelectPoint.accept(position)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    func hideSummaryView() {
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
    
    private func setInitialMarker() {
        fetchRestaurantList(zoom: 2000) {
            self.setInitialMapPoint()
        }
    }
    
    @objc
    private func presentDetailVC() {
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

// MARK: - Network

extension SupplementMapVC {
    private func fetchRestaurantSummary(id: String) {
        RestaurantService.shared.fetchRestaurantSummary(restaurantId: id, userId: UserManager.shared.getUser ?? "") { networkResult in
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
    
    private func fetchRestaurantList(zoom: Double, completion: @escaping (() -> Void)) {
        if let lng = locationManager?.currentLatLng().lng,
           let lat = locationManager?.currentLatLng().lat {
            RestaurantService.shared.fetchRestaurantList(longitude: lat, latitude: lng, zoom: zoom, category: "") { networkResult in
                switch networkResult {
                case .success(let data):
                    if let data = data as? [MainMapEntity] {
                        self.restaurantData = data
                        var models = [MapPointDataModel]()
                        var targetModel = [MapPointDataModel]()
                        models = data.map({ entity in
                            entity.toDomain()
                        })
                        
                        switch self.mapType {
                        case .scrap:
                            models.forEach { entity in
                                self.targetMarkerPointList.forEach { point in
                                    if point.longtitude == entity.longtitude,
                                       point.latitude == entity.latitude {
                                        targetModel.append(entity)
                                    }
                                }
                            }
                        case .search:
                            data.forEach { entity in
                                self.IDsForMap.forEach { id in
                                    if entity.id == id {
                                        targetModel.append(entity.toDomain())
                                    }
                                }
                            }
                        }

                        self.makePoints(points: targetModel).bind(to: self.mapView.rx.pointList)
                            .disposed(by: self.disposeBag)
                        
                        completion()
                    }
                default:
                    break
                }
            }
        }
    }
}
