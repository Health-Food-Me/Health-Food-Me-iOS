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

class SupplementMapVC: UIViewController, NMFLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let locationManager = NMFLocationManager.sharedInstance()
    
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
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - 189)
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
                self.mapView.disableSelectPoint.accept(())
                self.mapDetailSummaryView.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(UIScreen.main.bounds.height)
                }
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.mapDetailSummaryView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: self.disposeBag)
        
        mapView.setSelectPoint
            .subscribe(onNext: { [weak self] dataModel in
                let summaryViewHeight: CGFloat = 189
                self?.mapDetailSummaryView.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(UIScreen.main.bounds.height - summaryViewHeight)
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
