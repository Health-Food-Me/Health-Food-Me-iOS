//
//  SearchResultVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/13.
//

import UIKit

import SnapKit
import NMapsMap

protocol SearchResultVCDelegate: AnyObject {
    func searchResultVCSearchType(type: SearchType)
}

final class SearchResultVC: UIViewController {
    
    // MARK: - Properties
    
    enum FromSearchType {
        case searchRecent
        case searchCell
        case searchResult
    }
    var fromSearchType = FromSearchType.searchResult
    var fromSearchCellInitial: String = ""
    var searchContent: String = ""
    weak var delegate: SearchResultVCDelegate?
    private var isMapView: Bool = true
    var searchResultList: [SearchResultDataModel] = []
    private let locationManager = NMFLocationManager.sharedInstance()
    private let mapViewController: SupplementMapVC = {
        let vc = ModuleFactory.resolve().makeSupplementMapVC(forSearchVC: true)
        return vc
    }()
    let height = UIScreen.main.bounds.height
    
    // MARK: - UI Components
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        tf.font = .NotoRegular(size: 15)
        tf.text = searchContent
        tf.textColor = .helfmeBlack
        tf.backgroundColor = .helfmeWhite
        tf.leftView = backButton
        tf.rightView = resultCloseButton
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12)
        btn.setImage(ImageLiterals.Search.beforeIcon, for: .normal)
        return btn
    }()
    
    private lazy var resultCloseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.xIcon, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let searchResultHeaderView: UIView = UIView()
    
    private lazy var viewMapButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewMapBtn, for: .normal)
        btn.setTitle(I18N.Search.searchMap, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 12)
        btn.isHidden = true
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return btn
    }()
    
    private lazy var viewListButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewListBtn, for: .normal)
        btn.setTitle(I18N.Search.searchList, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 12)
        btn.isHidden = true
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return btn
    }()
    
    private lazy var searchResultTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = 127
        tv.backgroundColor = .helfmeWhite
        tv.keyboardDismissMode = .onDrag
        tv.tableHeaderView = searchResultHeaderView
        tv.layer.applyShadow(color: .black,
                             alpha: 0.1,
                             x: 0,
                             y: -3,
                             blur: 4,
                             spread: 0)
        return tv
    }()
    
    private let searchResultLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChildViewController()
        switch fromSearchType {
        case .searchRecent:
            break
        case .searchCell:
            setLayout()
            setUI()
            setResultVCForSummary()
            addBtnAction()
            setDelegate()
            registerCell()
        default:
            setLayout()
            setUI()
            viewMap()
            addBtnAction()
            setDelegate()
            registerCell()
        }
    }
}

// MARK: - Methods

extension SearchResultVC {
    private func setChildViewController() {
        mapViewController.IDsForMap = searchResultList.map({
            $0.id
        })
        
        mapViewController.navigationController?.navigationBar.isHidden = true
        mapViewController.delegate = self
        switch fromSearchType {
        case .searchCell:
            mapViewController.initialId = fromSearchCellInitial
            self.addChild(mapViewController)
            self.view.addSubview(mapViewController.view)
            mapViewController.didMove(toParent: self)
            mapViewController.setSupplementMapType(mapType: .search)
        case .searchRecent:
            fetchSearchResultData(keyword: searchContent, fromRecent: false)
        default:
            mapViewController.initialId = searchResultList.first?.id
            self.addChild(mapViewController)
            self.view.addSubview(mapViewController.view)
            mapViewController.didMove(toParent: self)
            mapViewController.setSupplementMapType(mapType: .search)
        }
    }
    
    private func fetchSearchResultData(keyword: String, fromRecent: Bool) {
        let NMGPosition = self.locationManager?.currentLatLng()
        var lng: Double = 0.0
        var lat: Double = 0.0
        if let position = NMGPosition {
            lng = position.lng
            lat = position.lat
        } else {
            lng = LocationLiterals.gangnamStation.lng
            lat = LocationLiterals.gangnamStation.lat
        }
        if let text = searchTextField.text {
            searchContent = text
        }
        requestRestaurantSearchResult(searchRequest: SearchRequestEntity(longitude: lng, latitude: lat,
                                                                         keyword: keyword), fromRecent: fromRecent) {
            self.mapViewController.initialId = self.fromSearchCellInitial
            self.mapViewController.IDsForMap = self.searchResultList.map({
                $0.id
            })
            self.addChild(self.mapViewController)
            self.view.addSubview(self.mapViewController.view)
            self.mapViewController.didMove(toParent: self)
            UIView.animate(withDuration: 0.2, animations: {
                self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            })
            self.setLayout()
            self.setUI()
            self.mapViewController.setSelectPointForSummary()
            self.setUIForViewMap()
            self.addBtnAction()
            self.setDelegate()
            self.registerCell()
        }
    }
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .helfmeWhite
    }
    
    private func addBtnAction() {
        backButton.press {
            switch self.fromSearchType {
            case .searchRecent:
                self.delegate?.searchResultVCSearchType(type: .recent)
                self.navigationController?.popViewController(animated: false)
            default:
                if self.isMapView {
                    self.viewList()
                } else {
                    self.delegate?.searchResultVCSearchType(type: .recent)
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
        
        resultCloseButton.press {
            guard let vcs = self.navigationController?.viewControllers else { return }
            for vc in vcs {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        
        viewMapButton.press {
            self.viewMap()
        }
        
        viewListButton.press {
            self.viewList()
        }
    }
    
    private func setLayout() {
        view.addSubviews(topView,
                         searchTextField,
                         lineView,
                         searchResultTableView)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(91)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(56)
        }
        
        resultCloseButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(44)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        searchResultHeaderView.addSubviews(viewMapButton, viewListButton)
        
        viewMapButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(67)
            $0.height.equalTo(16)
        }
        
        viewListButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(67)
            $0.height.equalTo(14)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResultTableView.addSubviews(searchResultLineView)
        
        searchResultLineView.snp.makeConstraints {
            $0.top.equalTo(searchResultTableView.snp.top).inset(8)
            $0.width.equalTo(70)
            $0.height.equalTo(3)
            $0.centerX.equalTo(searchResultTableView)
        }
    }
    
    private func setDelegate() {
        searchTextField.delegate = self
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    private func registerCell() {
        SearchResultTVC.register(target: searchResultTableView)
    }
    
    private func viewMap() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 585)
        })
        
        mapViewController.showSummaryViewForResult()
        
        setUIForViewMap()
    }
    
    private func setResultVCForSummary() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        })
        mapViewController.showSummaryViewForResult()
        mapViewController.setSelectPointForSummary()
        
        setUIForViewMap()
    }
    
    private func setUIForViewMap() {
        searchResultTableView.tableHeaderView?.frame.size.height = 40
        isMapView = true
        searchResultTableView.layer.shadowOpacity = 0.1
        searchResultTableView.layer.cornerRadius = 15
        searchResultLineView.isHidden = false
        viewMapButton.isHidden = true
        viewListButton.isHidden = false
    }
    
    private func viewList() {
        UIView.animate(withDuration: 0.2) {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.viewMapButton.isHidden = false
        } completion: { _ in
            self.view.bringSubviewToFront(self.topView)
            self.view.bringSubviewToFront(self.searchTextField)
            self.navigationController?.popViewController(animated: false)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchResultVCSearchType(type: .search)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UITableViewDelegate

extension SearchResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResultTableView.frame.origin.y < UIScreen.main.bounds.height / 2 {
            mapViewController.initialId = searchResultList[indexPath.row].id
            mapViewController.setInitialMapPoint(needShowSummary: true)
            setResultVCForSummary()
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTVC.className, for: indexPath) as? SearchResultTVC else { return UITableViewCell() }
        cell.setData(data: searchResultList[indexPath.row])
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            if isMapView {
                viewList()
            }
        }
    }
}

extension SearchResultVC: SupplementMapVCDelegate {
    func supplementMapClicked() {
        UIView.animate(withDuration: 0.2) {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 585)
        }
    }
    
    func supplementMapMarkerClicked() {
        UIView.animate(withDuration: 0.2) {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        } completion: { _ in
            self.mapViewController.showSummaryView()
        }
    }
}

// MARK: - Network

extension SearchResultVC {
    private func requestRestaurantSearchResult(searchRequest: SearchRequestEntity, fromRecent: Bool, completion: @escaping(() -> Void)) {
        RestaurantService.shared.requestRestaurantSearchResult(searchRequest: SearchRequestEntity(longitude: searchRequest.longitude,
                                                                                                  latitude: searchRequest.latitude,
                                                                                                  keyword: searchRequest.keyword)) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? [SearchResultEntity] {
                    self.searchResultList.removeAll()
                    for searchResultData in data {
                        self.searchResultList.append(searchResultData.toDomain())
                    }
                    self.searchResultList = self.searchResultList.sorted(by: { $0.distance < $1.distance })
                    completion()
                }
            default:
                break;
            }
        }
    }
}
