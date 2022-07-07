//
//  ExpandableInfoTVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/07.
//

import UIKit

import SnapKit
import RxRelay

final class ExpandableInfoTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    let toggleButtonTapped = PublishRelay<Bool>()
    var willUseExpandableOption: Bool = false
    var isFirstRow: Bool = false
    var isOpenned = false {
        didSet {
            
        }
    }
    
    // MARK: - UI Components
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isHidden = true
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "월요일 09:00~20:00"
        lb.textAlignment = .left
        lb.textColor = .black
//        lb.font = .PopBold(size: 16)
        return lb
    }()
    
    private let toggleButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.MainDetail.showdownIcon, for: .normal)
        bt.setImage(ImageLiterals.MainDetail.showupIcon, for: .normal)
        return bt
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

extension ExpandableInfoTVC {
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        self.addSubviews(iconImageView, infoLabel, toggleButton)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalTo(4.5)
        }
        
        infoLabel.snp.makeConstraints { make in
            
        }
        
        toggleButton.snp.makeConstraints { make in
            
        }
    }
    
    class func caculateRowHeihgt() -> CGFloat {
        return 140 + 50
    }
}
