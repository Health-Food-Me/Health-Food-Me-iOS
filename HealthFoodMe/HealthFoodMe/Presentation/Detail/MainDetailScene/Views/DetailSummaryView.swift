//
//  DetailSummaryView.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit

final class DetailSummaryView: UIView {
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let restaurantNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "샐러디 태릉입구점"
        lb.textColor = .black
//        lb.font = .PopBold(size: 16)
        return lb
    }()
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.text = "샐러드"
        lb.textColor = .lightGray
//        lb.font = .NotoBold(size: 13)
        return lb
    }()
    
    private let starStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 0
        st.distribution = .equalSpacing
        return st
    }()
    
    private let rateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "(4.3)"
        lb.textColor = .lightGray
//        lb.font = .NotoBold(size: 13)
        return lb
    }()
    
    // MARK: View Life Cycle
    
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

extension DetailSummaryView {
    func setData() {
    }
}

// MARK: - UI & Layout

extension DetailSummaryView {
   
    private func setUI() {
        self.backgroundColor = .carrotWhite
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(140)
        }
        
        self.addSubviews(logoImageView, restaurantNameLabel, categoryLabel, starStackView, rateLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(12)
            make.width.height.equalTo(116)
        }
        
        restaurantNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalTo(logoImageView.snp.trailing).offset(16)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(38)
            make.leading.equalTo(restaurantNameLabel.snp.trailing).offset(5)
        }
        
        setStarStackView()
        starStackView.snp.makeConstraints { make in
            make.leading.equalTo(restaurantNameLabel.snp.leading)
            make.top.equalTo(restaurantNameLabel.snp.bottom).offset(9)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(starStackView.snp.trailing).offset(8)
            make.top.equalTo(restaurantNameLabel.snp.bottom).offset(7)
        }
    }
    
    private func setStarStackView() {
        for starNumber in 1...5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = ImageLiterals.MainDetail.starIcon
            imageView.tag = starNumber
            starStackView.addArrangedSubviews(imageView)
        }
    }
}
