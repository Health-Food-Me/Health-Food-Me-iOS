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
    var mapType = SupplementMapType.scrap
    private let disposeBag = DisposeBag()
    private let locationManager = NMFLocationManager.sharedInstance()
    weak var delegate: SupplementMapVCDelegate?
    
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
        sampleViewInputEvent()
        setPanGesture()
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
        
        myLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset(-12)
            make.width.height.equalTo(56)
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
                    self.bindSetSelectPointForSearchVC()
                case .scrap:
                    self.bindSetSelectPointForScrapVC()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func bindMapViewClickedForSearchVC() {
        self.mapView.disableSelectPoint.accept(())
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
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
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindSetSelectPointForSearchVC() {
        delegate?.supplementMapMarkerClicked()
    }
    
    private func bindSetSelectPointForScrapVC() {
        showSummaryView()
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
                self.myLocationButton.isHidden = false
            }
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
        }
    }
    
    private func removeCustomNaviBar() {
        [statusTopView, customNavigationBar].forEach { view in
            view.isHidden = true
        }
    }
    
    private func updateConstraints() {
        myLocationButton.snp.updateConstraints { make in
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset(-100)
        }
    }
    
    func showSummaryView() {
        let summaryViewHeight: CGFloat = 189
        self.mapDetailSummaryView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
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
