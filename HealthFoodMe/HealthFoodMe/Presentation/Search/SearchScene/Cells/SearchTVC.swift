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
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
        view.isHidden = true
        return view
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
        if data.isCategory {
            setCategoryImage(name: data.title)
            lineView.isHidden = false
        }
        else if data.isDiet {
            searchImageView.image = ImageLiterals.Search.dietIcon
            lineView.isHidden = true
        } else {
            searchImageView.image = ImageLiterals.Search.normalIcon
            lineView.isHidden = true
        }
        searchLabel.text = data.title
        searchLabel.textColor = .helfmeBlack
        searchLabel.partColorChange(targetString: searchContent, textColor: .mainRed)
    }
    
    private func setCategoryImage(name: String) {
        switch (name) {
        case "샐러드":
            searchImageView.image = ImageLiterals.Map.saladIcon
        case "포케":
            searchImageView.image = ImageLiterals.Map.pokeIcon
        case "샌드위치":
            searchImageView.image = ImageLiterals.Map.sandwichIcon
        case "키토김밥":
            searchImageView.image = ImageLiterals.Map.kimbapIcon
        case "샤브샤브":
            searchImageView.image = ImageLiterals.Map.shabushabuIcon
        case "보쌈":
            searchImageView.image = ImageLiterals.Map.bossamIcon
        case "스테이크":
            searchImageView.image = ImageLiterals.Map.steakIcon
        case "덮밥":
            searchImageView.image = ImageLiterals.Map.dupbapIcon
        case "고깃집":
            searchImageView.image = ImageLiterals.Map.meatIcon
        case "도시락":
            searchImageView.image = ImageLiterals.Map.dosirakIcon
        default:
            return
        }
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
        selectionStyle = .none
    }
    
    private func setLayout() {
        contentView.addSubviews(searchImageView, searchLabel, lineView)
        
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
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}
