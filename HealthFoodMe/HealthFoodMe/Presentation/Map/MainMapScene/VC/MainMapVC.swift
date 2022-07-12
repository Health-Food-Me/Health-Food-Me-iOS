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
    
    private let searchLabel: UILabel = {
        let lb = UILabel()
        lb.text = "식당, 음식 검색"
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
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
        view.addSubviews(mapView, hamburgerButton, searchBar,
                         categoryCollectionView, mapDetailSummaryView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            make.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
    }
  
    private func bindViewModels() {
        let input = MainMapViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentSearchVC))
        searchBar.addGestureRecognizer(tapGesture)
    }
    
    private func resetUI() {
        navigationController?.isNavigationBarHidden =  true
    }
}

// MARK: - Network

extension MainMapVC {

}
