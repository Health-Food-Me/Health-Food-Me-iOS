//
//  CopingEmptyView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

class CopingEmptyView: UIView {
    
    // MARK: - Properties
  
    // MARK: - UI Components
    let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGreenSubLight
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeWhite
        lb.text = "#샤브샤브"
        lb.font = .NotoBold(size: 15)
        return lb
    }()
    
    
    let copingEmptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.helfmeLineGray.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let icnImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiterals.Coping.imageEmpty
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emptyLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.textAlignment = .center
        lb.numberOfLines = 2
        lb.text = I18N.Coping.copingEmpty
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    private let waitLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.text = I18N.Coping.copingWait
        lb.font = .NotoRegular(size: 14)
        return lb
    }()
    
    lazy var copingLabelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 24
        sv.addArrangedSubview(emptyLabel)
        sv.addArrangedSubview(waitLabel)
        return sv
    }()
    
    // MARK: - View Life Cycle
    
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

extension CopingEmptyView {
    private func setUI() {
        
    }

    private func setLayout() {
        
        self.addSubviews(copingEmptyView, categoryView)
        
        categoryView.snp.makeConstraints { make in
            make.centerX.equalTo(copingEmptyView.snp.centerX)
            make.centerY.equalTo(copingEmptyView.snp.top)
            make.height.equalTo(32)
            make.width.equalTo(117)
        }
        
        categoryView.addSubviews(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        copingEmptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        copingEmptyView.addSubviews(icnImageView, copingLabelStackView)
        
        icnImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.leading.equalToSuperview().offset(139)
            make.trailing.equalToSuperview().inset(120)
        }
        
        copingLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(icnImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
}
