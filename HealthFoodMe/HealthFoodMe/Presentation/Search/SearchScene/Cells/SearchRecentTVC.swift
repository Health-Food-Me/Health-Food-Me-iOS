//
//  SearchTVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import SnapKit

protocol SearchRecentTVCDelegate: AnyObject {
    func searchRecentTVCDelete(index: Int)
}

final class SearchRecentTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    weak var delegate: SearchRecentTVCDelegate?
    var index: Int = 0
    
    private var searchLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 16)
        return lb
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.deleteBtn, for: .normal)
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
}

// MARK: - @objc Methods

extension SearchRecentTVC {
    @objc func deleteSearch() {
        delegate?.searchRecentTVCDelete(index: index)
    }
}

// MARK: - Methods

extension SearchRecentTVC {
    func setData(data: String) {
        searchLabel.text = data
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
        selectionStyle = .none
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
