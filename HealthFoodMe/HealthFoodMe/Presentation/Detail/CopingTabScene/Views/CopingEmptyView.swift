//
//  CopingEmptyView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

class CopingEmptyView: UIView {
    
    // MARK: - UI Components
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CopingEmptyView {

    private func setLayout() {
        self.addSubviews(copingEmptyView)
        
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
