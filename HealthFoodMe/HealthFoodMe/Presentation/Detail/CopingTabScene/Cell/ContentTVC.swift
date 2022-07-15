//
//  contentTVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

class ContentTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    lazy var checkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiterals.Coping.icnTipGreen
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var contentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "먹는 속도가 자연스럽게 느려져요"
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 12)
        lb.numberOfLines = 0
        lb.layer.borderColor = UIColor.mainRed.cgColor
        lb.layer.borderWidth = 0.5
        return lb
    }()
    
    lazy var contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 10
        sv.addArrangedSubviews(checkImageView, contentLabel)
        return sv
    }()
    
    // MARK: - Life Cycle Part

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

extension ContentTVC {
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.contentView.addSubviews(contentStackView)
        
        checkImageView.snp.makeConstraints {  make in
            make.width.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints{ make in
            make.width.equalTo(228)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
//            make.leading.equalToSuperview().offset(38.5)
//            make.trailing.equalToSuperview().inset(38.5)
        }
        
    }
    
    func setData(section: Int, content: String) {
        if section == 0 {
            checkImageView.image = ImageLiterals.Coping.icnTipGreen
        } else {
            checkImageView.image = ImageLiterals.Coping.icnTipPink
        }
        contentLabel.text = content
    }
}
