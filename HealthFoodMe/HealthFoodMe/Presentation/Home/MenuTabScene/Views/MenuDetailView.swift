//
//  menuDetailView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

class MenuDetailView: UIView {
    
    // MARK: - Properties
  
    // MARK: - UI Components
    
    private let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.5
        view.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        return view
    }()
    
    private let kcalView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
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
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
    
    private let standardLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1인분 (50g)"
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 8)
        return lb
    }()
    
    lazy var cAmountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    private let cTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = "탄수화물"
        lb.textColor = .darkGray
        lb.font = .systemFont(ofSize: 8)
        return lb
    }()
    
    private lazy var carbohydrateStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.addArrangedSubview(cAmountLabel)
        sv.addArrangedSubview(cTextLabel)
        return sv
    }()
    
    lazy var pAmountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    private let pTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = "단백질"
        lb.textColor = .darkGray
        lb.font = .systemFont(ofSize: 8)
        return lb
    }()
    
    private lazy var proteinStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.addArrangedSubview(pAmountLabel)
        sv.addArrangedSubview(pTextLabel)
        return sv
    }()
    
    lazy var fAmountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    private let fTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = "지방"
        lb.textColor = .darkGray
        lb.font = .systemFont(ofSize: 8)
        return lb
    }()
    
    private lazy var fatsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 4
        sv.addArrangedSubview(fAmountLabel)
        sv.addArrangedSubview(fTextLabel)
        return sv
    }()
    
    private lazy var nutrientStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 10
        sv.addArrangedSubview(carbohydrateStackView)
        sv.addArrangedSubview(proteinStackView)
        sv.addArrangedSubview(fatsStackView)
        return sv
    }()
    
    lazy var kcalLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 16)
        return lb
    }()
    
    private let unitLabel: UILabel = {
        let lb = UILabel()
        lb.text = "kcal"
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 10)
        return lb
    }()
   
    private lazy var kcalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 3
        sv.addArrangedSubview(kcalLabel)
        sv.addArrangedSubview(unitLabel)
        return sv
    }()
  
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MenuDetailView {
    private func setUI() {
        
    }
    
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
