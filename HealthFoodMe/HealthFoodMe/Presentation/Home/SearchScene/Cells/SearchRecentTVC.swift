//
//  SearchTVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import SnapKit

protocol SearchRecentTVCDelegate: AnyObject {
    func SearchRecentTVCDelete(index: Int)
}

final class SearchRecentTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    static var cellIdentifier: String { return String(describing: self) }
    
    weak var delegate: SearchRecentTVCDelegate?

    var index: Int = 0
    
    private var searchLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 16)
        return lb
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.addTarget(self, action: #selector(deleteSearch), for: .touchUpInside)
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
        delegate?.SearchRecentTVCDelete(index: index)
    }
}

// MARK: - Methods

extension SearchRecentTVC {
    func setData(data: String) {
        searchLabel.text = data
    }
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setLayout() {
        contentView.addSubviews(searchLabel, deleteButton)
        
        searchLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(24)
        }
    }
}
