//
//  ExpandableInfoTVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/07.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class ExpandableInfoTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    let disposeBag = DisposeBag()
    let toggleButtonTapped = PublishRelay<Void>()
    var willUseExpandableOption: Bool = false
    var isOpenned = false {
        didSet {
            
        }
    }
    
    // MARK: - UI Components
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = ImageLiterals.MainDetail.locationIcon
        iv.isHidden = false
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
    
    private lazy var toggleButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.MainDetail.showdownIcon, for: .normal)
        bt.setImage(ImageLiterals.MainDetail.showupIcon, for: .selected)
        bt.addAction(UIAction(handler: { _ in
            self.isOpenned.toggle()
            print(self.isOpenned)
            print(1)
            self.toggleButtonTapped.accept(())
        }), for: .touchUpInside)
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
        self.contentView.addSubviews(iconImageView, infoLabel, toggleButton)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(20)
            make.top.bottom.equalTo(4.5)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12.5)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.leading.equalTo(infoLabel.snp.trailing).offset(2)
            make.centerY.equalTo(infoLabel.snp.centerY)
        }
    }
    
    func setUIWithIndex(indexPath: IndexPath, isOppend: Bool) {
        let isFirstRow = indexPath.row == 0
        let isSecondSection = indexPath.section == 1
        toggleButton.isSelected = isOpenned
        
        iconImageView.isHidden = !isFirstRow
        toggleButton.isHidden = !(isFirstRow && isSecondSection)
    }
    
    class func caculateRowHeihgt() -> CGFloat {
        return 140 + 50
    }
}
