//
//  HelfmeNaviBar.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import UIKit

import SnapKit

final class HelfmeNaviBar: UIView {
    
    // MARK: - Properties
    
    var buttonClosure: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleView: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.text = I18N.Scrap.scrapTitle
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    private lazy var scrapBackButton: UIButton = {
        let bt = UIButton()
        bt.setImage(ImageLiterals.Scrap.beforeIcon, for: .normal)
        bt.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonClosure?()
        }), for: .touchUpInside)
        return bt
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGray1
        return view
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
}

// MARK: - Methods

extension HelfmeNaviBar {
   
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(48)
        }
        
        self.addSubviews(scrapBackButton, titleView, lineView)
        
        scrapBackButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
            make.width.height.equalTo(24)
        }
        
        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.3)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}



