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
        iv.image = ImageLiterals.MainDetail.tempSalady
        return iv
    }()
    
    private var foodLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .mainGreen
        lb.text = "샐러드"
        lb.font = .NotoMedium(size: 10)
        return lb
    }()
    
    private var storeNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.text = "써브웨이 동대문역사문화공원역점"
        lb.setLineSpacingWithChaining(lineSpacing: 2)
          .lineBreakStrategy = .hangulWordPriority
        lb.font = .NotoBold(size: 14)
        lb.numberOfLines = 0
        return lb
    }()
    
    private var starView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGreen
        return view
    }()
    
    private var distanceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeGray1
        lb.text = "거리: 50m"
        lb.font = .NotoMedium(size: 10)
        return lb
    }()
    
    private lazy var storeStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubviews(foodLabel)
        sv.addArrangedSubviews(storeNameLabel)
        sv.addArrangedSubviews(starView)
        sv.addArrangedSubviews(distanceLabel)
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
    func setData(data: [String]) {
        
    }
    
    private func setUI() {
        backgroundColor = .helfmeWhite
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
            $0.width.equalTo(91)
            $0.height.equalTo(14)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.trailing.equalTo(storeView.snp.trailing).inset(35)
        }
    }
}
