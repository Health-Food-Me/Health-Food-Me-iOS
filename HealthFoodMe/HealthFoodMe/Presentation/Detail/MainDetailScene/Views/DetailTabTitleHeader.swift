//
//  DetailTabTitleHeader.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit

final class DetailTabTitleHeader: UITableViewHeaderFooterView, UITableViewHeaderFooterRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    private var selectedButton: Int = 0
    private let buttonTitles: [String] = ["메뉴", "외식대처법", "리뷰"]
    
    // MARK: - UI Components
    
    private var titleButtons: [UIButton] = []
    
    private var buttonStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 0
        st.distribution = .equalSpacing
        return st
    }()
    
//    private let selectorBar: UICollectionView = {
//        let cv = UICollectionView()
//        return cv
//    }()
    
    // MARK: - View Life Cycles
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setUI()
        setLayout()
        setAddTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Methods

extension DetailTabTitleHeader {
    func setData() {

    }
}

// MARK: UI & Layout

extension DetailTabTitleHeader {
    private func setUI() {
        setButtons()
    }
        
    private func setButtons() {
        for buttonIndex in 0...2 {
            let bt = UIButton()
            bt.setTitle(buttonTitles[buttonIndex], for: .normal)
            bt.backgroundColor = .white
            bt.tag = buttonIndex
            bt.isSelected = buttonIndex == 0
            bt.setTitleColor(.black, for: .selected)
            bt.setTitleColor(.blue, for: .normal)
            titleButtons.append(bt)
        }
    }
    
    private func setLayout() {
        self.addSubviews(buttonStackView)
        
        titleButtons.forEach({ button in
            let buttonWidth = UIScreen.main.bounds.width/3
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
            }
            buttonStackView.addArrangedSubview(button)
        })
        
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setAddTargets() {
        titleButtons.forEach { button in
            button.addTarget(self, action: #selector(setSelectedButton), for: .touchUpInside)
        }
    }
    
    @objc
    private func setSelectedButton(sender: UIButton) {
        self.selectedButton = sender.tag
        
        titleButtons.forEach { button in
            button.isSelected = sender == button
        }
    }
}
