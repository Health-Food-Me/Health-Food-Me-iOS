//
//  ScrapCVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit

protocol ScrapCVCDelegate: AnyObject {
    func scrapCVCButtonDidTap(restaurantId: String)
}

class ScrapCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    weak var delegate: ScrapCVCDelegate?
    var restaurantId: String = ""
  
    // MARK: - UI Components
    
    private var storeImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var scrapButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Scrap.bookmarkIcon, for: .normal)
        btn.setImage(ImageLiterals.Scrap.bookmarkInactiveIcon, for: .selected)
        btn.addTarget(self, action: #selector(didTapScrapButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private var storeNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .NotoMedium(size: 14)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    
    private let locationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
  
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @objc Methods

extension ScrapCVC {
    @objc func didTapScrapButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.scrapCVCButtonDidTap(restaurantId: restaurantId)
    }
}

// MARK: - Methods

extension ScrapCVC {
    func setData(data: ScrapListEntity) {
        storeImageView.image = UIImage(named: data.logo)
        storeNameLabel.text = data.name
        locationLabel.text = data.address
    }
    
    private func setUI() {
        contentView.layer.borderColor = UIColor.helfmeLineGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        contentView.addSubviews(storeImageView, scrapButton, storeNameLabel,
                                locationLabel)
        
        storeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.height.width.equalTo(28)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(storeImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
