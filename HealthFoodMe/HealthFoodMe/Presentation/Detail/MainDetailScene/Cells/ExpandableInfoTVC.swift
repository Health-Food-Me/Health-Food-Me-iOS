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
    let telePhoneLabelTapped = PublishRelay<String>()
    
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
        lb.textColor = .helfmeGray1
        lb.font = .NotoMedium(size: 12)
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    private lazy var toggleButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.MainDetail.showdownIcon, for: .normal)
        bt.setImage(ImageLiterals.MainDetail.showupIcon, for: .selected)
        bt.addAction(UIAction(handler: { _ in
            bt.isSelected.toggle()
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
        self.contentView.backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        self.contentView.addSubviews(iconImageView, infoLabel, toggleButton)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
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
    
    func setUIWithIndex(indexPath: IndexPath) {
        let isFirstRow = indexPath.row == 0
        let isSecondSection = indexPath.section == 1
        
        switch indexPath.section {
        case 0:
            iconImageView.image = ImageLiterals.MainDetail.locationIcon
            infoLabel.text = "서울특별시 중랑구 상봉동"
        case 1:
            iconImageView.image = ImageLiterals.MainDetail.timeIcon
        default:
            iconImageView.image = ImageLiterals.MainDetail.phoneIcon
            let telephoneString = "02-123-123"
            let attributeString = NSMutableAttributedString(string: telephoneString)
            attributeString.addAttribute(.underlineStyle, value: 1, range: NSRange.init(location: 0, length: telephoneString.count))
            infoLabel.attributedText = attributeString
            setTapGesture()
        }
        
        iconImageView.isHidden = !isFirstRow
        toggleButton.isHidden = !(isFirstRow && isSecondSection)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentTelephoneApp))
        infoLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func presentTelephoneApp() {
        if let text = infoLabel.text {
            telePhoneLabelTapped.accept(text)
        }
    }
}
