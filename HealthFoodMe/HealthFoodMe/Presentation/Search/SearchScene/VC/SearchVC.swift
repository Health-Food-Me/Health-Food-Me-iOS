//
//  SearchVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import RealmSwift
import SnapKit

enum SearchType {
    case recent
    case search
    case searchResult
}

final class SearchVC: UIViewController {
    
    // MARK: - Properties
    
    let realm = try? Realm()
    var searchType: SearchType = SearchType.recent {
        didSet {
            searchTableView.reloadData()
        }
    }
    var searchDataModel: [SearchResultModel] = []
    var searchRecentList: [String] = []
    
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
        tf.attributedPlaceholder = NSAttributedString(string: "식당, 음식 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.helfmeTagGray])
        tf.font = .NotoRegular(size: 15)
        tf.textColor = .helfmeBlack
        tf.backgroundColor = .helfmeWhite
        tf.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        tf.leftView = backButton
        tf.rightView = clearButton
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        btn.setImage(ImageLiterals.Search.beforeIcon, for: .normal)
        btn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.textDeleteBtn, for: .normal)
        btn.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
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
        lb.text = "최근 검색어"
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private lazy var resultHeaderButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewMapBtn, for: .normal)
        btn.setTitle("지도 뷰로 보기", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(pushToSearchResultVC), for: .touchUpInside)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
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
        tv.tableHeaderView?.frame.size.height = 56
        return tv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        initTextField()
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
            print("화면 전환")
        case .search:
            print("화면 전환")
        case .searchResult:
            isEmptyTextField()
            initTextField()
        }
    }
    
    @objc func didTapClearButton() {
        searchTextField.text?.removeAll()
        isEmptyTextField()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if searchTextField.isEmpty {
            isEmptyTextField()
        } else {
            searchTextField.rightViewMode = .always
            searchTableView.tableHeaderView = nil
            searchType = .search
        }
    }
    
    @objc func pushToSearchResultVC() {
        let searchResultVC = ModuleFactory.resolve().makeSearchResultVC()
        searchResultVC.delegate = self
        if let searchText = searchTextField.text {
            searchResultVC.searchContent = searchText
        }
        navigationController?.pushViewController(searchResultVC, animated: false)
    }
}

// MARK: - Methods

extension SearchVC {
    private func initTextField() {
        if searchType == .recent {
            searchTextField.text?.removeAll()
        }
    }
    
    private func setData() {
        let savedSearchRecent = realm?.objects(SearchRecent.self)
        savedSearchRecent?.forEach { object in
            searchRecentList.insert(object.title, at: 0)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .helfmeWhite
        dismissKeyboard()
        self.navigationController?.isNavigationBarHidden = true
        searchTextField.text?.removeAll()
    }
    
    private func setLayout() {
        view.addSubviews(searchTextField, lineView, searchView)
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(36)
        }
        
        clearButton.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        searchHeaderView.addSubviews(recentHeaderLabel, resultHeaderButton)
        
        recentHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.top).offset(20)
            $0.leading.equalTo(searchHeaderView.snp.leading).inset(20)
        }
        
        resultHeaderButton.snp.makeConstraints {
            $0.trailing.equalTo(searchHeaderView.snp.trailing).inset(20)
            $0.centerY.equalTo(searchHeaderView)
            $0.width.equalTo(105)
            $0.height.equalTo(20)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchView.addSubviews(searchTableView)
        
        searchTableView.snp.makeConstraints {
            $0.edges.equalTo(searchView)
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
        let searchRecent = SearchRecent()
        searchRecent.title = title
        try? realm?.write {
            realm?.add(searchRecent)
        }
        searchRecentList.insert(title, at: 0)
    }
    
    private func isEmptyTextField() {
        searchTextField.rightViewMode = .never
        searchTableView.tableHeaderView = searchHeaderView
        resultHeaderButton.isHidden = true
        recentHeaderLabel.isHidden = false
        searchType = .recent
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            addSearchRecent(title: text)
        }
        searchType = .searchResult
        clearButton.isHidden = true
        recentHeaderLabel.isHidden = true
        resultHeaderButton.isHidden = false
        searchTableView.tableHeaderView = searchHeaderView
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false
        searchType = .search
        searchTextField.becomeFirstResponder()
        searchTableView.tableHeaderView = nil
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
            return searchRecentList.count
        case .searchResult:
            return searchRecentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .recent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecentTVC.className, for: indexPath) as? SearchRecentTVC else { return UITableViewCell() }
            cell.setData(data: searchRecentList[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .search:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.className, for: indexPath) as? SearchTVC else { return UITableViewCell() }
            cell.setData(data: searchRecentList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case .searchResult:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTVC.className, for: indexPath) as? SearchResultTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            //            cell.setData(data: searchRecentList[indexPath.row])
            //            cell.index = indexPath.row
            //            cell.delegate = self
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
        searchType = type
        if type == .search {
            searchTextField.becomeFirstResponder()
        } else {
            isEmptyTextField()
        }
    }
}

// MARK: - Network
