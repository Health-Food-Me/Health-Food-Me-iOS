//
//  SearchVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import SnapKit

final class SearchVC: UIViewController {
    
    // MARK: - Properties
    
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
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if searchTextField.isEmpty {
            searchTextField.rightViewMode = .never
        } else {
            searchTextField.rightViewMode = .always
        }
    }
}

// MARK: - Methods

extension SearchVC {
    private func setUI() {
        dismissKeyboard()
    }
    
    private func setLayout() {
        recentView.addSubviews(recentLabel)
        
        recentLabel.snp.makeConstraints {
            $0.top.equalTo(recentView.snp.top).offset(20)
            $0.leading.equalTo(recentView.snp.leading).inset(20)
        }
        
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
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.cellIdentifier, for: indexPath) as? SearchTVC else { return UITableViewCell() }
        cell.setData(data: "샐러디")
        return cell
    }
}

// MARK: - Network
