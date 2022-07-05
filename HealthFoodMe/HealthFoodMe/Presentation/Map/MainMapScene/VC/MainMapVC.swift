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
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension MainMapVC {
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        view.addSubviews(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
  
    private func bindViewModels() {
        let input = MainMapViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }

}

// MARK: - Network

extension MainMapVC {

}
