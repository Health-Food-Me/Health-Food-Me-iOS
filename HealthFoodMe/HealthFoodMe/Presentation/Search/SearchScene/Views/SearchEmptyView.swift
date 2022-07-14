//
//  SearchEmptyView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/13.
//

import UIKit

class SearchEmptyView: UIView {
    
    // MARK: - Properties
    
    private let searchEmptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiterals.Search.imageSearch
        return iv
    }()
    
    private let searchEmptyLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Search.searchEmpty
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 18)
        return lb
    }()
    
    private let searchAnotherLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Search.searchAnother
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension SearchEmptyView {
    private func setUI() {
        backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        addSubviews(searchEmptyImageView,
                    searchEmptyLabel,
                    searchAnotherLabel)
        
        searchEmptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.centerX.equalToSuperview()
        }
        
        searchEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(searchEmptyImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        searchAnotherLabel.snp.makeConstraints {
            $0.top.equalTo(searchEmptyLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
