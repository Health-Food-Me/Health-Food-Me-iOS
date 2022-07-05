//
//  SearchTVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import SnapKit

final class SearchTVC: UITableViewCell {

    // MARK: - Properties
    
    static var cellIdentifier: String { return String(describing: self) }
    
    private var searchLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
    
    private var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.addTarget(SearchTVC.self, action: #selector(deleteSearch), for: .touchUpInside)
        return btn
    }()
  
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc Methods
    
    @objc func deleteSearch() {
        
    }
}

// MARK: - Methods

extension SearchTVC {
    func setData(data: String) {
        searchLabel.text = data
    }
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setLayout() {
        contentView.addSubviews(searchLabel, deleteButton)
        
        searchLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}
