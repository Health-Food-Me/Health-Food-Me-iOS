//
//  ScrapCVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit

protocol ScrapCVCDelegate: AnyObject {
    func scrapCVCButtonDidTap(index: Int, isSelected: Bool)
}

class ScrapCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    var index: Int = 0
    weak var delegate: ScrapCVCDelegate?
  
    // MARK: - UI Components
    
    private var storeImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var scrapButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Scrap.bookmarkInactiveIcon, for: .normal)
        btn.setImage(ImageLiterals.Scrap.bookmarkIcon, for: .selected)
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
        delegate?.scrapCVCButtonDidTap(index: index, isSelected: sender.isSelected)
    }
}

// MARK: - Methods

extension ScrapCVC {
    func setData(data: ScrapDataModel) {
        storeImageView.image = UIImage(named: data.scrapimageUrl)
        storeNameLabel.text = data.storeName
        locationLabel.text = data.storeLocation
    }
    
    private func setUI() {
        contentView.layer.borderColor = UIColor.helfmeLineGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        contentView.addSubviews(storeImageView,
                                scrapButton,
                                storeNameLabel,
                                locationLabel)
        
        storeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(160)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.trailing.equalToSuperview().inset(13)
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
