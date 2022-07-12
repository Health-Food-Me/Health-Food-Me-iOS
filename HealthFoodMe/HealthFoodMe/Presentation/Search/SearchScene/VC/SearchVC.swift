//
//  SearchVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import RealmSwift
import SnapKit

final class SearchVC: UIViewController {
    
    // MARK: - Properties
    
    let realm = try? Realm()
    var searchStarted: Bool = false {
        didSet {
            searchTableView.reloadData()
        }
    }
    var searchRecentList: [String] = []
    
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
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let topView: UIView = UIView()
    
    private let topLabel: UILabel = {
        let lb = UILabel()
        lb.text = "최근 검색어"
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = 56
        tv.backgroundColor = .helfmeWhite
        tv.keyboardDismissMode = .onDrag
        tv.tableHeaderView = topView
        tv.tableHeaderView?.frame.size.height = 56
        return tv
    }()
    
    // MARK: - View Life Cycle
    
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
            searchStarted = true
        }
    }
}

// MARK: - Methods

extension SearchVC {
    private func setData() {
        let savedSearchRecent = realm?.objects(SearchRecent.self)
        savedSearchRecent?.forEach { object in
            searchRecentList.insert(object.title, at: 0)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .helfmeWhite
        dismissKeyboard()
    }
    
    private func setLayout() {
        view.addSubviews(searchTextField, lineView, searchTableView)
        
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
        
        topView.addSubviews(topLabel)
        
        topLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.top).offset(20)
            $0.leading.equalTo(topView.snp.leading).inset(20)
        }
        
        searchTableView.snp.makeConstraints {
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
        topLabel.text = "최근 검색어"
        searchTableView.tableHeaderView = topView
        searchStarted = false
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            addSearchRecent(title: text)
        }
        return true
    }
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchStarted {
            return searchRecentList.count
        } else {
            return searchRecentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchStarted {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.className, for: indexPath) as? SearchTVC else { return UITableViewCell() }
            cell.setData(data: searchRecentList[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecentTVC.className, for: indexPath) as? SearchRecentTVC else { return UITableViewCell() }
            cell.setData(data: searchRecentList[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - SearchTVCDelegate

extension SearchVC: SearchRecentTVCDelegate {
    func searchRecentTVCDelete(index: Int) {
        try? realm?.write {
            if let savedSearchRecent =  realm?.objects(SearchRecent.self).filter("title == '\(searchRecentList[index])'") {
                print(savedSearchRecent)
                realm?.delete(savedSearchRecent)
            }
        }
        searchRecentList.remove(at: index)
        searchTableView.reloadData()
    }
}

// MARK: - Network
