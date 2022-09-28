//
//  SearchResultTVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/12.
//

import UIKit

import SnapKit

final class SearchResultTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private var storeView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.helfmeLineGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var storeImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private var foodLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .mainGreen
        lb.font = .NotoMedium(size: 10)
        return lb
    }()
    
    private var storeNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.setLineSpacingWithChaining(lineSpacing: 2)
          .lineBreakStrategy = .hangulWordPriority
        lb.font = .NotoBold(size: 14)
        lb.numberOfLines = 0
        return lb
    }()
    
    private var starView: StarRatingView = {
        let st = StarRatingView(starScale: 14, spacing: 0)
        return st
    }()
    
    private var starLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
    
    private lazy var starStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubviews(starView, starLabel)
        sv.alignment = .top
        sv.axis = .horizontal
        sv.spacing = 4
        return sv
    }()
    
    private var distanceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeGray1
        lb.font = .NotoMedium(size: 10)
        return lb
    }()
    
    private lazy var storeStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubviews(foodLabel,
                               storeNameLabel,
                               starStackView,
                               distanceLabel)
        sv.alignment = .leading
        sv.axis = .vertical
        sv.spacing = 2
        return sv
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

extension SearchResultTVC {
    func setData(data: SearchResultDataModel, category: String?) {
        storeImageView.setImage(with: data.imgURL)
        if let category = category {
            foodLabel.text = category
        } else {
            foodLabel.text = data.foodCategory[0]
        }
        storeNameLabel.text = data.storeName
        starView.rate = data.starRate
        starLabel.text = "(\(data.starRate))"
        if data.distance < 1000 {
            distanceLabel.text = "거리: \(data.distance))m"
        } else {
            distanceLabel.text = "거리: \(round(data.distance / 1000))km"
        }
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
        selectionStyle = .none
    }
    
    private func setLayout() {
        contentView.addSubviews(storeView)
        
        storeView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(6)
        }
        
        storeView.addSubviews(storeImageView, storeStackView)
        
        storeImageView.snp.makeConstraints {
            $0.leading.equalTo(storeView.snp.leading).inset(16)
            $0.width.height.equalTo(91)
            $0.top.bottom.equalTo(storeView).inset(12)
        }

        storeStackView.snp.makeConstraints {
            $0.leading.equalTo(storeImageView.snp.trailing).offset(20)
            $0.centerY.equalTo(storeView)
        }
        
        starView.snp.makeConstraints {
            let width = UIScreen.main.bounds.width * (70/375)
            $0.leading.equalTo(storeStackView.snp.leading)
            $0.width.equalTo(width)
            $0.height.equalTo(width * (14/70))
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.trailing.equalTo(storeView.snp.trailing).inset(35)
        }
    }
}
