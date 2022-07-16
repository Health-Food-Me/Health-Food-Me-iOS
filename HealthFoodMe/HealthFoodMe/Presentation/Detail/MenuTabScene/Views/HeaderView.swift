//
//  HeaderView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/06.
//

import UIKit

protocol MenuCVCDelegate: AnyObject {
    func controlSegement()
}

final class HeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: MenuCVCDelegate?

    // MARK: - UI Components
    private let segementcontrol: CustomSegmentControl = {
            let sc = CustomSegmentControl(titleList: ["메뉴", "영양정보"])
            return sc
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

extension HeaderView {
    private func setLayout() {
        self.addSubview(segementcontrol)
        segementcontrol.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        delegate?.controlSegement()
    }
}
