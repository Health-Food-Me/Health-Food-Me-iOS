//
//  SearchView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import SnapKit

final class SearchView: UIView {
    
    // MARK: - Properties
    
    private lazy var searchTopView = SearchTopView()
    
    private let recentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "최근 검색어"
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 13)
        return lb
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchTVC.self, forCellReuseIdentifier: SearchTVC.cellIdentifier)
        tableView.rowHeight = 50
        tableView.backgroundColor = .white
        return tableView
    }()
    
    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension SearchView {
    private func setUI() {
        searchTableView.keyboardDismissMode = .onDrag
    }
    
    private func setLayout() {
        addSubviews(searchTopView, recentLabel, searchTableView)
        
        searchTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalTo(searchTopView.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension SearchView: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.cellIdentifier, for: indexPath) as? SearchTVC else { return UITableViewCell() }
        cell.setData(data: "샐러디")
        return cell
    }
}
