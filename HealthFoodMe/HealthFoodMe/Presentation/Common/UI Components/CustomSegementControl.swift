//
//  CustomSegementControl.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/13.
//

import UIKit

import SnapKit

final class CustomSegmentControl: UIView {
    
    internal var areaClickEvent: ((Int) -> Void)?
    internal var containerColor: UIColor = .init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    internal var selectColor: UIColor = .white
    internal var titleList: [String] = []
    internal var width: CGFloat = 226
    private lazy var selectedView = UIView()
    private lazy var containerStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
        setStackView()
    }
    
    convenience init(titleList: [String]) {
        self.init()
        self.titleList = titleList
        setUI()
        setStackView()
    }
}

extension CustomSegmentControl {
    private func setStackView() {
        containerStackView.axis = .horizontal
        containerStackView.spacing = 0
        containerStackView.distribution = .fillEqually
        for (index, _) in titleList.enumerated() {
            let buttonContainerView = UIView()
            let button = UIButton()
            let titleLabel = UILabel()

            titleLabel.textAlignment = .center
            titleLabel.text = titleList[index]
            titleLabel.textColor = UIColor.init(red: 34/255,
                                                green: 34/255,
                                                blue: 34/255,
                                                alpha: 1)
            titleLabel.font = UIFont.NotoMedium(size: 12)
            buttonContainerView.addSubview(button)
            buttonContainerView.addSubview(titleLabel)

            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            titleLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }

            button.backgroundColor = .clear
            button.tag = index
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            containerStackView.addArrangedSubview(buttonContainerView)
        }
    }
    
    private func setUI() {
        guard titleList.count > 0 else { return }
        backgroundColor = containerColor
        layer.cornerRadius = 20
        selectedView.backgroundColor = selectColor
        selectedView.layer.cornerRadius = 16
        containerStackView.backgroundColor = .clear
        
        addSubview(selectedView)
        addSubview(containerStackView)
        
        selectedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo( (width - 8) / CGFloat(titleList.count))
        }
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    func buttonClicked(_ button: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let buttonTag = button.tag
        areaClickEvent?(buttonTag)
        let buttonWidth = (width - 8) / CGFloat(titleList.count)
        selectedView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(buttonTag) * buttonWidth + 4)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
