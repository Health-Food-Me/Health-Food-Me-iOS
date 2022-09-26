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
        lb.textColor = .helfmeBlack
        lb.font = .NotoRegular(size: 12)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    
    lazy var contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .top
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
        let screenWidth = UIScreen.main.bounds.width
        self.contentView.addSubviews(contentStackView)
        
        checkImageView.snp.makeConstraints {  make in
            make.width.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 170)
            make.trailing.equalTo(contentStackView.snp.trailing)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview().inset(9)
            make.centerX.equalToSuperview()
        }
    }
    
    func setData(section: Int, content: String, isLast: Bool) {
        if section == 0 {
            checkImageView.image = ImageLiterals.Coping.icnTipGreen
        } else {
            checkImageView.image = ImageLiterals.Coping.icnTipPink
        }
        contentLabel.text = content
        updateBottomCellMargin(isLast)
    }
    
    private func updateBottomCellMargin( _ isLast: Bool) {
        let bottomMargin: CGFloat = isLast ? 52 : 9
        contentStackView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(bottomMargin)
        }
    }
}
