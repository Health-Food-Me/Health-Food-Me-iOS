//
//  DetailTabTitleHeader.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class DetailTabTitleHeader: UITableViewHeaderFooterView, UITableViewHeaderFooterRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    let disposeBag = DisposeBag()
    let titleButtonTapped = PublishRelay<Int>()
    private var selectedButton: Int = 0 {
        didSet {
            titleButtonTapped.accept(selectedButton)
        }
    }
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
    
    private let tabIndicator: TabIndicator = {
        let tabIndicator = TabIndicator()
        tabIndicator.widthRatio = 1/3
        tabIndicator.backgroundColor = .white
        return tabIndicator
    }()
    
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
            bt.setTitle(I18N.Detail.Main.buttonTitles[buttonIndex], for: .normal)
            bt.backgroundColor = .white
            bt.tag = buttonIndex
            bt.isSelected = buttonIndex == 0
            bt.titleLabel?.font = .NotoBold(size: 14)
            bt.setTitleColor(.mainRed, for: .selected)
            bt.setTitleColor(.helfmeGray1, for: .normal)
            titleButtons.append(bt)
        }
    }
    
    private func setLayout() {
        self.addSubviews(buttonStackView, tabIndicator)
        
        titleButtons.forEach({ button in
            let buttonWidth = UIScreen.main.bounds.width/3
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
            }
            buttonStackView.addArrangedSubview(button)
        })
        
        buttonStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        tabIndicator.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.left.right.equalTo(buttonStackView)
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setAddTargets() {
        titleButtons.forEach { button in
            button.addTarget(self, action: #selector(changeSelectedButton), for: .touchUpInside)
        }
    }
    
    @objc
    private func changeSelectedButton(sender: UIButton) {
        self.selectedButton = sender.tag
        
        titleButtons.forEach { button in
            button.isSelected = sender == button
        }
    }
    
    func moveWithContinuousRatio(ratio: CGFloat) {
        tabIndicator.leftOffsetRatio = ratio
    }
    
    func setSelectedButton(buttonIndex: Int) {
        titleButtons.forEach { button in
            button.isSelected = button.tag == buttonIndex
        }
    }
}
