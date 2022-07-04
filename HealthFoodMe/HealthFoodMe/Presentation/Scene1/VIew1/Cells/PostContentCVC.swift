//
//  PostContentCVC.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/18.
//

import UIKit

import SnapKit

protocol PostContentDelegate: AnyObject {
    func presentSellStatusActionSheet()
}

final class PostContentCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    weak var delegate: PostContentDelegate?
    
    private let sellStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .carrotWhite
        view.layer.borderColor = UIColor.carrotSquareGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let sellStatusLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .carrotBlack
//        lb.font = .PopExtraBold(size: 14)
        lb.text = "판매중"
        lb.textAlignment = .center
        return lb
    }()
    
    private let sellArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.layer.masksToBounds = true
        iv.image = ImageLiterals.PostDetail.arrowIcon
        return iv
    }()
    
    private let postTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .carrotBlack
//        lb.font = .PopExtraBold(size: 19)
        lb.text = "최태성 한능검 심화 기출 500제"
        return lb
    }()
    
    private lazy var categoryButton: UIButton = {
        let bt = UIButton()
        bt.setTitleColor(UIColor.carrotDarkLightGray, for: .normal)
        bt.setTitle("도서/티켓/음반", for: .normal)
//        bt.titleLabel?.font = .PopMedium(size: 13)
        bt.setUnderline()
        return bt
    }()

    private let timeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "5분 전"
        lb.textColor = .carrotDarkLightGray
//        lb.font = .PopMedium(size: 13)
        return lb
    }()
    
    private let postContentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "새책입니다."
        lb.textColor = .carrotBlack
//        lb.font = .PopMedium(size: 15)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    
    private let viewCountLabel: UILabel = {
        let lb = UILabel()
        lb.text = "조회 3"
        lb.textColor = .carrotDarkLightGray
//        lb.font = .PopMedium(size: 13)
        return lb
    }()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
        setAddTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom Methods
    
    private func setAddTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentActionSheet))
        sellStatusView.addGestureRecognizer(tap)
    }
    
    func setData(data: PostDetail) {
        changeSellStatus(status: data.onSale)
        postTitleLabel.text = data.title
        categoryButton.setTitle(data.category, for: .normal)
        timeLabel.text = data.createdAt
        postContentLabel.text = data.title
        viewCountLabel.text = "조희 \(data.view)"
    }
    
    func changeSellStatus(status: String) {
        switch status {
        case "0": sellStatusLabel.text = "판매중"
        case "1": sellStatusLabel.text = "예약중"
        case "2": sellStatusLabel.text = "거래 완료"
        default: sellStatusLabel.text = "판매중"
        }
    }
    
    // MARK: @objc methods
    
    @objc
    private func presentActionSheet() {
        delegate?.presentSellStatusActionSheet()
    }
    
    // MARK: UI & Layout
    
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        addSubviews(sellStatusView, postTitleLabel, categoryButton,
                    timeLabel, postContentLabel, viewCountLabel)
        
        sellStatusView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(99)
            make.height.equalTo(39)
        }
        
        sellStatusView.addSubviews(sellStatusLabel, sellArrowImageView)
        
        sellStatusLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(11)
            make.centerY.equalToSuperview()
        }
        
        sellArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        postTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(sellStatusView.snp.bottom).offset(14)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.leading.equalTo(postTitleLabel.snp.leading)
            make.top.equalTo(postTitleLabel.snp.bottom).offset(7)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryButton.snp.trailing).offset(9)
            make.centerY.equalTo(categoryButton.snp.centerY)
        }
        
        postContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(postTitleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(categoryButton.snp.bottom).offset(14)
        }
        
        viewCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(postTitleLabel.snp.leading)
            make.top.equalTo(postContentLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(46)
        }
    }
}
