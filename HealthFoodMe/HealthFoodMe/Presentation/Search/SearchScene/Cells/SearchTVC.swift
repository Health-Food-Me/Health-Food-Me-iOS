//
//  SearchTVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/08.
//

import UIKit

import SnapKit

final class SearchTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    var searchContent: String = ""
    
    private var searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var searchLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 16)
        return lb
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

// MARK: - Methods

extension SearchTVC {
    func setData(data: SearchDataModel) {
        if data.isDiet {
            searchImageView.image = ImageLiterals.Search.dietIcon
        } else {
            searchImageView.image = ImageLiterals.Search.normalIcon
        }
        searchLabel.text = data.title
        searchLabel.partColorChange(targetString: searchContent, textColor: .mainRed)
        print(searchContent)
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
        selectionStyle = .none
    }
    
    private func setLayout() {
        contentView.addSubviews(searchImageView, searchLabel)
        
        searchImageView.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerY.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
        
        searchLabel.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
}
