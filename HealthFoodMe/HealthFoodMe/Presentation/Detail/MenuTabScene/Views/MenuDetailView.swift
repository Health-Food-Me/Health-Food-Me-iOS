//
//  menuDetailView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

final class MenuDetailView: UIView {
    
    // MARK: - UI Components
    
    private let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.helfmeLineGray.cgColor
        view.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        return view
    }()
    
    private let kcalView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGreen
        view.roundCorners(cornerRadius: 15, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        return view
    }()
    
    let pickImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 15)
        return lb
    }()
    
    private let standardLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Menu.standard
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 8)
        return lb
    }()
    
    lazy var carbohydrateAmountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .PretendardMedium(size: 14)
        return lb
    }()
    
    private let carbohydrateTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Menu.carbohydrate
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 9)
        return lb
    }()
    
    private lazy var carbohydrateStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.addArrangedSubviews(carbohydrateAmountLabel, carbohydrateTextLabel)
        return sv
    }()
    
    lazy var proteinAmountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .PretendardMedium(size: 14)
        return lb
    }()
    
    private let proteinTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Menu.protein
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 9)
        return lb
    }()
    
    private lazy var proteinStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.addArrangedSubviews(proteinAmountLabel, proteinTextLabel)
        return sv
    }()
    
    lazy var fatsAmountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = .PretendardMedium(size: 14)
        return lb
    }()
    
    private let fatsTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Menu.fats
        lb.textColor = .helfmeGray1
        lb.font = .NotoRegular(size: 9)
        return lb
    }()
    
    private lazy var fatsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.addArrangedSubviews(fatsAmountLabel, fatsTextLabel)
        return sv
    }()
    
    private lazy var nutrientStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 10
        sv.addArrangedSubviews(carbohydrateStackView, proteinStackView, fatsStackView)
        return sv
    }()
    
    lazy var kcalLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeWhite
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    private let unitLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Menu.kcalUnit
        lb.textColor = .helfmeWhite
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
   
    private lazy var kcalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 0
        sv.addArrangedSubview(kcalLabel)
        sv.addArrangedSubview(unitLabel)
        return sv
    }()
  
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MenuDetailView {
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(120)
        }
        
        self.addSubviews(menuView, kcalView)
        
        menuView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(kcalView.snp.leading)
        }
        
        kcalView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(55)
        }
        
        menuView.addSubviews(pickImageView, titleLabel, standardLabel, nutrientStackView)
        
        pickImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pickImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(28)
        }
        
        standardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.trailing.equalTo(kcalView.snp.leading).offset(-26)
        }
        
        nutrientStackView.snp.makeConstraints { make in
            make.top.equalTo(standardLabel.snp.bottom).offset(5)
            make.trailing.equalTo(kcalView.snp.leading).offset(-26)
        }
        
        kcalView.addSubview(kcalStackView)
        kcalStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
