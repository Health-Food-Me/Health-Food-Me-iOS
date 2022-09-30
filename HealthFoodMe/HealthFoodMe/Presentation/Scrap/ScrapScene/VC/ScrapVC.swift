//
//  ScrapVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit
import RealmSwift

class ScrapVC: UIViewController {
    
    // MARK: - Properties
    
    private let scrapEmptyView = ScrapEmptyView()
    private var scrapList: [ScrapListEntity] = []
    var cancelScrapList: [String] = []
    
    // MARK: - UI Components
    
    private let scrapTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private lazy var scrapBackButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Scrap.beforeIcon, for: .normal)
        btn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return btn
    }()
    
    private let scrapTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Scrap.scrapTitle
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    private let scrapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        scrapCollectionView.reloadData()
        scrapCollectionView.setContentOffset(CGPointZero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setUI()
        setLayout()
        setDelegate()
        registerCell()
    }
}

// MARK: - @objc Methods

extension ScrapVC {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Methods

extension ScrapVC {
    private func fetchData() {
        getScrapList(userId: UserManager.shared.getUserId ?? "")
        isScrapEmpty()
    }
    
    private func isScrapEmpty() {
        scrapEmptyView.isHidden = !scrapList.isEmpty
    }
    
    private func setUI() {
        scrapEmptyView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(scrapTopView,
                         lineView,
                         scrapCollectionView,
                         scrapEmptyView)
        
        scrapTopView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        scrapTopView.addSubviews(scrapBackButton, scrapTitleLabel)
        
        scrapBackButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(scrapTopView)
        }
        
        scrapTitleLabel.snp.makeConstraints {
            $0.center.equalTo(scrapTopView)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(scrapTopView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        scrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrapEmptyView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        scrapCollectionView.delegate = self
        scrapCollectionView.dataSource = self
        scrapEmptyView.delegate = self
    }
    
    private func registerCell() {
        ScrapCVC.register(target: scrapCollectionView)
    }
}

// MARK: - UICollectionViewDelegate

extension ScrapVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let vc = ModuleFactory.resolve().makeSupplementMapVC(forSearchVC: false)
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationController?.isToolbarHidden = false
        vc.navigationController?.setNavigationBarHidden(false, animated: false)
        var pointList = [MapPointDataModel]()
        scrapList.forEach { entity in
            pointList.append(entity.toDomain())
        }
        let initialPoint = scrapList[indexPath.row]
        vc.initialPoint = MapPointDataModel.init(latitude: initialPoint.latitude, longtitude: initialPoint.longtitude, restaurantName: nil, type: .normalFood)
        vc.targetMarkerPointList = pointList
        vc.cancelScrapClosure = { cancel in
            self.cancelScrapList = self.cancelScrapList.filter { $0 != cancel.restaurantId }
            if cancel.isCancel {
                self.cancelScrapList.append(cancel.restaurantId)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ScrapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scrapList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCVC.className, for: indexPath) as? ScrapCVC else { return UICollectionViewCell() }
        cell.setData(data: scrapList[indexPath.row])
        cell.restaurantId = scrapList[indexPath.row]._id
        cell.delegate = self
        if !(cancelScrapList.filter{ $0 == scrapList[indexPath.row]._id }.isEmpty) {
            cell.setScrap(data: cancelScrapList.first ?? "")
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScrapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        let cellWidth = width * (160/375)
        let cellHeight = cellWidth * (232/160)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 15, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension ScrapVC: ScrapCVCDelegate {
    func scrapCVCButtonDidTap(restaurantId: String, isCancel: Bool) {
        putScrap(userId: UserManager.shared.getUserId ?? "", restaurantId: restaurantId)
        self.cancelScrapList = self.cancelScrapList.filter { $0 != restaurantId }
        if isCancel {
            self.cancelScrapList.append(restaurantId)
        }
    }
}

extension ScrapVC: ScrapEmptyViewDelegate {
    func scrapEmptyViewDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network

extension ScrapVC {
    func getScrapList(userId: String) {
        UserService.shared.getScrapList(userId: userId) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? [ScrapListEntity] {
                    self.scrapList = data
                    self.isScrapEmpty()
                    self.scrapCollectionView.reloadData()
                }
            default:
                break;
            }
        }
    }
    
    func putScrap(userId: String, restaurantId: String) {
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
