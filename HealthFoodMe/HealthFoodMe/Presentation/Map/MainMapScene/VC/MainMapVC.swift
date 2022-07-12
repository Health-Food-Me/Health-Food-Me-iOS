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

class MainMapVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MainMapViewModel!
    
    private var locationManager = CLLocationManager()
    private var currentLatitude: Double?
    private var currentLongitude: Double?
  
    // MARK: - UI Components
    
    private lazy var mapView: NMFMapView = {
        let map = NMFMapView()
        map.locationOverlay.hidden = false
        return map
    }()
    
    private lazy var hamburgerButton: UIButton =  {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.menuIcon, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let nextVC = ModuleFactory.resolve().makeMainDetailVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
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
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        self.bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
    }
}

// MARK: - Methods

extension MainMapVC {
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(mapView, tempDetailButton)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tempDetailButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.equalToSuperview().inset(50)
        }
    }
  
    private func bindViewModels() {
        let input = MainMapViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    private func resetUI() {
        navigationController?.isNavigationBarHidden =  true
    }
}

// MARK: - Network

extension MainMapVC {

}
