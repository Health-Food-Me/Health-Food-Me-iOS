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
    private var locationManager = CLLocationManager()
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    var viewModel: MainMapViewModel!
    
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
            let nextVC = ModuleFactory.resolve().makeHamburgerBarVC()
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
        return cv
    }()
    
    private let scrapButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.scrapIcon, for: .normal)
        bt.setImage(ImageLiterals.MainDetail.scrapIcon_filled, for: .selected)
        bt.addAction(UIAction(handler: { _ in
            bt.isSelected.toggle()
        }), for: .touchUpInside)
        bt.backgroundColor = .helfmeWhite
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 28
        bt.layer.applyShadow(color: .helfmeBlack, alpha: 0.2, x: 0, y: 2, blur: 4, spread: 0)
        return bt
    }()
    
    private let myLocationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Map.mylocationIcon, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            
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
                         categoryCollectionView, mapDetailSummaryView, scrapButton,
                         myLocationButton)
        
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
        
        categoryCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(hamburgerButton.snp.bottom).offset(12)
            make.height.equalTo(32 + 10)
        }
        
        mapDetailSummaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height - 189)
            make.height.equalTo(UIScreen.main.bounds.height + 300)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(myLocationButton.snp.top).offset(-12)
            make.width.height.equalTo(56)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(mapDetailSummaryView.snp.top).offset(-12)
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
                    if summaryViewTranslation.y < -90
                        || (self?.mapDetailSummaryView.frame.origin.y ?? 40 < 30) {
                        self?.mapDetailSummaryView.snp.updateConstraints { make in
                            make.top.equalToSuperview().inset(44)
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
                            self?.scrapButton.isHidden = false
                            self?.myLocationButton.isHidden = false
                        }
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModels() {
        let input = MainMapViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    private func resetUI() {
        navigationController?.isNavigationBarHidden =  true
    }
    
    @objc
    private func presentSearchVC() {
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
            }
        }
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .currentContext
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true) {
            self.mapDetailSummaryView.isHidden = true
        }
    }
}

// MARK: - CollectionView Delegate

extension MainMapVC: UICollectionViewDelegate {
    
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
        cell.setData(data: MainMapCategory.categorySample[indexPath.row])
        return cell
    }
}
