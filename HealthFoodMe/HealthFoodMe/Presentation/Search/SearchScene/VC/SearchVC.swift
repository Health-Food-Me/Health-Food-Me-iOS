//
//  SearchVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import RealmSwift
import RxSwift
import SnapKit
import NMapsMap

enum SearchType {
    case recent
    case search
    case searchResult
}

final class SearchVC: UIViewController {
    
    // MARK: - Properties
    
    private let locationManager = NMFLocationManager.sharedInstance()
    private let disposeBag = DisposeBag()
    let realm = try? Realm()
    var searchType: SearchType = SearchType.recent {
        didSet {
            searchTableView.reloadData()
        }
    }
    var searchContent: String = ""
    var searchRecentList: [String] = []
    var searchList: [SearchDataModel] = []
    var searchResultList: [SearchResultDataModel] = []
    private var searchEmptyView = SearchEmptyView()
    
    // MARK: - UI Components
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainRed
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.leftViewMode = .always
        tf.rightViewMode = .never
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: I18N.Search.search, attributes: [NSAttributedString.Key.foregroundColor: UIColor.helfmeTagGray])
        tf.font = .NotoRegular(size: 15)
        tf.textColor = .helfmeBlack
        tf.backgroundColor = .helfmeWhite
        tf.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        tf.leftView = backButton
        tf.rightView = clearButton
        tf.autocorrectionType = .no
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12)
        btn.setImage(ImageLiterals.Search.beforeIcon, for: .normal)
        btn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.textDeleteBtn, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        btn.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var resultCloseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.xIcon, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        btn.addTarget(self, action: #selector(popToMainMapVC), for: .touchUpInside)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let searchHeaderView: UIView = UIView()
    
    private let recentHeaderLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Search.searchRecent
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private lazy var viewMapButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewMapBtn, for: .normal)
        btn.setTitle(I18N.Search.searchMap, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 12)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(pushToSearchResultVC), for: .touchUpInside)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 20)
        return btn
    }()
    
    private lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = 56
        tv.backgroundColor = .helfmeWhite
        tv.keyboardDismissMode = .onDrag
        tv.tableHeaderView = searchHeaderView
        tv.tableHeaderView?.frame.size.height = 50
        return tv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        setRecentTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setUI()
        setLayout()
        setDelegate()
        registerCell()
    }
}

// MARK: - @objc Methods

extension SearchVC {
    @objc func didTapBackButton() {
        switch searchType {
        case .recent:
            navigationController?.popViewController(animated: true)
        case .search:
            isSearchRecent()
            setRecentTextField()
        case .searchResult:
            isSearchRecent()
            setRecentTextField()
        }
    }
    
    @objc func didTapClearButton() {
        searchTextField.text?.removeAll()
        isSearchRecent()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if searchTextField.isEmpty {
            isSearchRecent()
        } else {
            searchTextField.rightViewMode = .always
            fetchSearchData()
        }
    }
    
    @objc func pushToSearchResultVC() {
        let searchResultVC = ModuleFactory.resolve().makeSearchResultVC()
        searchResultVC.delegate = self
        if let searchText = searchTextField.text {
            searchResultVC.searchContent = searchText
            searchResultVC.searchResultList = searchResultList
        }
        navigationController?.pushViewController(searchResultVC, animated: false)
    }
    
    @objc func popToMainMapVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Methods

extension SearchVC {
    
    private func setRecentTextField() {
        if searchType == .recent {
            searchTextField.text?.removeAll()
            searchTextField.resignFirstResponder()
        }
    }
    
    //    private func setTextField() {
    //        searchTextField.rx.text.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
    //            .subscribe(onNext: { text in
    //                if let searchContent = text {
    //                    self.fetchSearchData(text: searchContent)
    //                }
    //            }).disposed(by: disposeBag)
    //    }
    
    private func setData() {
        let savedSearchRecent = realm?.objects(SearchRecent.self)
        savedSearchRecent?.forEach { object in
            searchRecentList.insert(object.title, at: 0)
        }
    }
    
    private func fetchSearchData() {
        if let text = searchTextField.text {
            let searchContent = text.trimmingCharacters(in: .whitespaces)
            if !searchContent.isEmpty {
                requestRestaurantSearch(query: searchContent)
            }
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
        requestRestaurantSearchResult(searchRequest: SearchRequestEntity(longitude: lat, latitude: lng,
                                                                         keyword: keyword), fromRecent: fromRecent)
    }
    
    private func setUI() {
        view.backgroundColor = .helfmeWhite
        dismissKeyboard()
        self.navigationController?.isNavigationBarHidden = true
        searchTextField.text?.removeAll()
        searchTextField.becomeFirstResponder()
        searchEmptyView.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(searchTextField,
                         lineView,
                         searchView,
                         searchEmptyView)
        
        searchTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(56)
        }
        
        clearButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(40)
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
        
        searchHeaderView.addSubviews(recentHeaderLabel, viewMapButton)
        
        recentHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.top).offset(20)
            $0.leading.equalTo(searchHeaderView.snp.leading).inset(20)
        }
        
        viewMapButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(67)
            $0.height.equalTo(16)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchView.addSubviews(searchTableView)
        
        searchTableView.snp.makeConstraints {
            $0.edges.equalTo(searchView)
        }
        
        searchEmptyView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        searchTextField.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    private func registerCell() {
        SearchRecentTVC.register(target: searchTableView)
        SearchTVC.register(target: searchTableView)
        SearchResultTVC.register(target: searchTableView)
    }
    
    func addSearchRecent(title: String) {
        try? realm?.write {
            if let savedSearchRecent = realm?.objects(SearchRecent.self).filter("title == '\(title)'") {
                realm?.delete(savedSearchRecent)
                searchRecentList = searchRecentList.filter { $0 != title }
            }
            let searchRecent = SearchRecent()
            searchRecent.title = title
            realm?.add(searchRecent)
        }
        searchRecentList.insert(title, at: 0)
    }
    
    private func isSearchRecent() {
        searchTextField.rightViewMode = .never
        searchTableView.tableHeaderView = searchHeaderView
        recentHeaderLabel.isHidden = false
        viewMapButton.isHidden = true
        searchEmptyView.isHidden = true
        searchType = .recent
    }
    
    private func isSearch() {
        searchTextField.rightView = clearButton
        searchTextField.becomeFirstResponder()
        searchTableView.tableHeaderView = nil
        searchEmptyView.isHidden = true
        searchType = .search
    }
    
    private func isSearchResult(fromRecent: Bool) {
        if searchList.isEmpty && !fromRecent {
            searchEmptyView.isHidden = false
        } else {
            searchEmptyView.isHidden = true
            searchTextField.resignFirstResponder()
            if let text = searchTextField.text {
                if !searchList.isEmpty {
                    addSearchRecent(title: text)
                }
            }
            searchTableView.tableHeaderView = searchHeaderView
            searchTableView.tableHeaderView?.frame.size.height = 42
            recentHeaderLabel.isHidden = true
            viewMapButton.isHidden = false
        }
        searchTextField.rightViewMode = .always
        searchTextField.rightView = resultCloseButton
        searchType = .searchResult
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = searchTextField.text {
            let searchContent = text.trimmingCharacters(in: .whitespaces)
            if !searchContent.isEmpty {
                fetchSearchResultData(keyword: searchContent, fromRecent: false)
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if searchType == .searchResult {
            fetchSearchData()
            isSearch()
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .recent:
            return searchRecentList.count
        case .search:
            return searchList.count
        case .searchResult:
            return searchResultList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .recent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecentTVC.className, for: indexPath) as? SearchRecentTVC else { return UITableViewCell() }
            cell.setData(data: searchRecentList[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case .search:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.className, for: indexPath) as? SearchTVC else { return UITableViewCell() }
            if let text = searchTextField.text {
                cell.searchContent = text
            }
            cell.setData(data: searchList[indexPath.row])
            return cell
        case .searchResult:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTVC.className, for: indexPath) as? SearchResultTVC else { return UITableViewCell() }
            cell.setData(data: searchResultList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch searchType {
        case .recent:
            return 56
        case .search:
            return 56
        case .searchResult:
            return 127
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchType {
        case .recent:
            searchTextField.text = searchRecentList[indexPath.row]
            fetchSearchResultData(keyword: searchRecentList[indexPath.row], fromRecent: true)
            addSearchRecent(title: searchRecentList[indexPath.row])
        case .search:
            searchTextField.text = searchList[indexPath.row].title
            let searchResultVC = ModuleFactory.resolve().makeSearchResultVC()
            searchResultVC.delegate = self
            searchResultVC.fromSearchType = .searchRecent
            searchResultVC.fromSearchCellInitial = searchList[indexPath.row].id
            searchResultVC.searchContent = searchList[indexPath.row].title
            searchResultVC.searchResultList = searchResultList
            navigationController?.pushViewController(searchResultVC, animated: false)
            addSearchRecent(title: searchList[indexPath.row].title)
        case .searchResult:
            searchTextField.text = searchResultList[indexPath.row].storeName
            let searchResultVC = ModuleFactory.resolve().makeSearchResultVC()
            searchResultVC.delegate = self
            searchResultVC.fromSearchType = .searchCell
            searchResultVC.fromSearchCellInitial = searchResultList[indexPath.row].id
            searchResultVC.searchContent = searchResultList[indexPath.row].storeName
            searchResultVC.searchResultList = searchResultList
            navigationController?.pushViewController(searchResultVC, animated: false)
            addSearchRecent(title: searchResultList[indexPath.row].storeName)
        }
    }
}

// MARK: - SearchTVCDelegate

extension SearchVC: SearchRecentTVCDelegate {
    func searchRecentTVCDelete(index: Int) {
        try? realm?.write {
            if let savedSearchRecent =  realm?.objects(SearchRecent.self).filter("title == '\(searchRecentList[index])'") {
                realm?.delete(savedSearchRecent)
            }
        }
        searchRecentList.remove(at: index)
        searchTableView.reloadData()
    }
}

// MARK: - SearchResultVCDelegate

extension SearchVC: SearchResultVCDelegate {
    func searchResultVCSearchType(type: SearchType) {
        if type == .search {
            searchTextField.becomeFirstResponder()
            clearButton.isHidden = false
            fetchSearchData()
        } else {
            isSearchRecent()
        }
    }
}

// MARK: - Network

extension SearchVC {
    private func requestRestaurantSearch(query: String) {
        RestaurantService.shared.requestRestaurantSearch(query: query) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? [SearchEntity] {
                    self.searchList.removeAll()
                    for searchData in data {
                        self.searchList.append(searchData.toDomain())
                    }
                    self.isSearch()
                    self.searchTableView.reloadData()
                }
            default:
                break;
            }
        }
    }
    
    private func requestRestaurantSearchResult(searchRequest: SearchRequestEntity, fromRecent: Bool) {
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
                    self.isSearchResult(fromRecent: fromRecent)
                    self.searchTableView.reloadData()
                }
            default:
                break;
            }
        }
    }
}
