//
//  PostDetailBottomView.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/05/17.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PostDetailBottomView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var likeButtonTapped = PublishRelay<Bool>()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .carrotLineLightGray
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.PostDetail.heartOffIcon, for: .normal)
        bt.setImage(ImageLiterals.PostDetail.hearOnIcon, for: .selected)
        bt.adjustsImageWhenHighlighted = false
        bt.addAction(UIAction(handler: { [weak self] _ in
            self?.likeButtonTapped.accept(bt.isSelected)
        }),for: .touchUpInside)
        return bt
    }()
    
    private let verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .carrotLineLightGray
        return view
    }()
    
    private let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "16,000원"
        lb.textColor = .carrotBlack
//        lb.font = .PopBold(size: 16)
        return lb
    }()
    
    private let guideLabel: UILabel = {
        let lb = UILabel()
        lb.text = "가격제안불가"
        lb.textColor = .carrotDarkLightGray
//        lb.font = .NotoBold(size: 13)
        return lb
    }()
    
    private lazy var chatButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .carrotButtonOrange
//        bt.titleLabel?.font = .NotoBold(size: 15)
        bt.setTitle("채팅 목록 보기", for: .normal)
        bt.setTitleColor(UIColor.carrotWhite, for: .normal)
        bt.layer.cornerRadius = 5
        return bt
    }()
    
    // MARK: View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func setData(data: PostDetail) {
        let price = String(data.price).replacingOccurrences(of: ",", with: "")
        priceLabel.text = numberFormatter(number: Int(price)!) + "원"
        
        likeButton.isSelected = data.isLiked
        guideLabel.text = data.isPriceSuggestion ? "가격제안가능" : "가격제안불가"
    }
    
    // MARK: - Private Methods
    
    private func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .carrotWhite
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(102)
        }
        
        self.addSubviews(lineView, likeButton, verticalLineView,
                         priceLabel, guideLabel, chatButton)
        
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(29)
        }
        
        verticalLineView.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton.snp.centerY)
            make.leading.equalTo(likeButton.snp.trailing).offset(16)
            make.width.equalTo(1)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(verticalLineView.snp.trailing).offset(18)
            make.top.equalTo(lineView.snp.bottom).offset(20)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.leading.equalTo(verticalLineView.snp.trailing).offset(18)
            make.top.equalTo(priceLabel.snp.bottom).offset(3)
        }
        
        chatButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(41)
            make.width.equalTo(122)
        }
    }
}
