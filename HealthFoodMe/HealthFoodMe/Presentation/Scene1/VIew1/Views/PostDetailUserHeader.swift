//
//  PostDetailUserHeader.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/18.
//

import UIKit

import SnapKit

final class PostDetailUserHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .carrotBlack
//        lb.font = .NotoBold(size: 16)
        lb.text = "Usssj"
        lb.textAlignment = .center
        return lb
    }()
    
    private let guideLabel: UILabel = {
        let lb = UILabel()
        lb.text = "개봉동"
        lb.textColor = .carrotBlack
//        lb.font = .PopLight(size: 12)
        return lb
    }()
    
    private let temperatureLabel: UILabel = {
        let lb = UILabel()
        lb.text = "36.5°C"
        lb.textColor = .carrotBlue
//        lb.font = .NunitoExtraBold(size: 16)
        return lb
    }()
    
    private let temperatureProgressBar: UIProgressView = {
        let pb = UIProgressView()
        pb.progressTintColor = .carrotBlue
        pb.trackTintColor = .carrotSquareLightGray
        pb.layer.cornerRadius = 3
        pb.progress = 36.5/100
        return pb
    }()
    
    private lazy var faceImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = ImageLiterals.PostDetail.faceIcon
        return iv
    }()
    
    private lazy var mannerButton: UIButton = {
        let bt = UIButton()
        bt.setTitleColor(UIColor.carrotDarkLightGray, for: .normal)
        bt.setTitle("매너온도", for: .normal)
//        bt.titleLabel?.font = .PopLight(size: 12)
        bt.setUnderline()
        return bt
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .carrotLineLightGray
        return view
    }()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom Methods
    
    func setData(data: PostDetail) {
        nameLabel.text = data.user.name
//        profileImageView.setImage(with: data.user.profile)
        guideLabel.text = data.user.region
    }
    
    // MARK: UI & Layout
    
    private func setUI() {
        self.backgroundColor = .carrotWhite
    }
    
    private func setLayout() {
        addSubviews(profileImageView, nameLabel, guideLabel,
                    temperatureLabel, temperatureProgressBar, faceImageView,
                    mannerButton, bottomLineView)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(23)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalTo(faceImageView.snp.leading).offset(-8)
        }
        
        temperatureProgressBar.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(4)
            make.trailing.equalTo(faceImageView.snp.leading).offset(-8)
            make.width.equalTo(50)
        }
        
        faceImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(24)
            make.top.equalToSuperview().inset(21)
        }
        
        mannerButton.snp.makeConstraints { make in
            make.top.equalTo(faceImageView.snp.bottom).offset(2)
            make.trailing.equalToSuperview().inset(15)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width-30)
            make.height.equalTo(1)
        }
    }
}
