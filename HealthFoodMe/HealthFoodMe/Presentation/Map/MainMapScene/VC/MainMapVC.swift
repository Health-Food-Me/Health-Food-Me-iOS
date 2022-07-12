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
    
    private lazy var tempDetailButton: UIButton =  {
        let bt = UIButton()
        bt.setTitle("디테일로 이동", for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let nextVC = ModuleFactory.resolve().makeMainDetailVC()
            nextVC.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(nextVC, animated: true)
        }), for: .touchUpInside)
        bt.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return bt
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
