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
     
    var searchRecentList: [String] = [] {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.leftViewMode = .always
        tf.rightViewMode = .never
        tf.attributedPlaceholder = NSAttributedString(string: "식당, 음식 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.font = .systemFont(ofSize: 15)
        tf.textColor = .black
        tf.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        tf.leftView = backButton
        tf.rightView = clearButton
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        btn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "x.circle"), for: .normal)
        btn.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let recentView: UIView = UIView()
    
    private let recentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "최근 검색어"
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    private lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.register(SearchTVC.self, forCellReuseIdentifier: SearchTVC.cellIdentifier)
        tv.rowHeight = 56
        tv.backgroundColor = .white
        tv.keyboardDismissMode = .onDrag
        tv.tableHeaderView = recentView
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
    }
    
    // MARK: - @objc Methods
    
    @objc func didTapBackButton() {
        
    }
    
    @objc func didTapClearButton() {
        searchTextField.text?.removeAll()
        searchTextField.rightViewMode = .never
        recentLabel.text = "최근 검색어"
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if searchTextField.isEmpty {
            searchTextField.rightViewMode = .never
            recentLabel.text = "최근 검색어"
        } else {
            searchTextField.rightViewMode = .always
            recentLabel.text = "자동 완성어"
        }
    }
}

// MARK: - Methods

extension SearchVC {
    private func setData() {
        let savedSearchRecent = realm?.objects(SearchRecent.self)
        savedSearchRecent?.forEach { object in
            searchRecentList.append(object.title)
        }
    }
    
    private func setUI() {
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
        
        recentView.addSubviews(recentLabel)
        
        recentLabel.snp.makeConstraints {
            $0.top.equalTo(recentView.snp.top).offset(20)
            $0.leading.equalTo(recentView.snp.leading).inset(20)
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
    
    func createSearchRecent(title: String) {
        let searchRecent = SearchRecent()
        searchRecent.title = title
        try? realm?.write {
            realm?.add(searchRecent)
        }
        searchRecentList.append(title)
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        createSearchRecent(title: textField.text ?? "")
        return true
    }
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRecentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.cellIdentifier, for: indexPath) as? SearchTVC else { return UITableViewCell() }
        cell.setData(data: searchRecentList[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
}

// MARK: - SearchTVCDelegate

extension SearchVC: SearchTVCDelegate {
    func SearchTVCDelete(index: Int) {
        let savedSearchRecent = realm?.objects(SearchRecent.self)
        try? realm?.write {
            realm?.delete(savedSearchRecent?[index] ?? SearchRecent())
        }
        searchRecentList.remove(at: index)
    }
}

// MARK: - Network
