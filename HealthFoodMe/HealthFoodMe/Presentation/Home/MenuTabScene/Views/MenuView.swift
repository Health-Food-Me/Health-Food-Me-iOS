//
//  menuView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

import SnapKit

final class MenuView: UIView {
    
    // MARK: - Properties
  
    // MARK: - UI Components
    
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        return view
    }()
    
    let kcalView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.roundCorners(cornerRadius: 15, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        return view
    }()
    
    lazy var menuImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var pickImageView: UIImageView = {
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
    
    lazy var priceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 12)
        return lb
    }()
   
    lazy var menuStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 3
        sv.addArrangedSubview(titleLabel)
        sv.addArrangedSubview(priceLabel)
        return sv
    }()
    
    lazy var kcalLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var unitLabel: UILabel = {
        let lb = UILabel()
        lb.text = "kcal"
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 10)
        return lb
    }()
   
    lazy var kcalStackView: UIStackView = {
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

extension MenuView {
    private func setUI() {
        self.backgroundColor = .white
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
            make.height.equalTo(120)
        }
        
        kcalView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(55)
        }
        
        menuView.addSubviews(menuImageView, pickImageView, menuStackView)
        
        menuImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(85)
        }
        
        pickImageView.snp.makeConstraints { make in
            make.leading.equalTo(menuImageView.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        
        menuStackView.snp.makeConstraints { make in
            make.leading.equalTo(menuImageView.snp.trailing).offset(20)
            make.top.equalTo(pickImageView).offset(24)
        }
        
        kcalView.addSubview(kcalStackView)
        kcalStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
