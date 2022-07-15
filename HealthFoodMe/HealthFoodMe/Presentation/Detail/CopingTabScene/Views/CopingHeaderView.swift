//
//  CopingHeaderView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

import SnapKit

final class CopingHeaderView: UITableViewHeaderFooterView, UITableViewHeaderFooterRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    lazy var icnImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var headerLabel: UILabel = {
        let lb = UILabel()
        lb.font = .NotoBold(size: 15)
        return lb
    }()

    // MARK: - View Life Cycles
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Methods

extension CopingHeaderView {
    
    func setHeaderData(section: Int) {
        if section == 0 {
            icnImageView.image = ImageLiterals.Coping.imageRecommend
            headerLabel.text = I18N.Coping.recommendHeader
            headerLabel.textColor = .mainGreen
        } else {
            icnImageView.image = ImageLiterals.Coping.imagetasteIt
            headerLabel.text = I18N.Coping.eatingHeader
            headerLabel.textColor = .mainRed
        }
    }
}

// MARK: UI & Layout

extension CopingHeaderView {
    
    private func setLayout() {
        self.addSubviews(icnImageView, headerLabel)
        
        icnImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(55)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(icnImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
