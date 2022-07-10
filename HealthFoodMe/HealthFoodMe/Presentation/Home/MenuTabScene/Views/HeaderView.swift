//
//  HeaderView.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/06.
//

import UIKit

final class HeaderView: UIView {
    
    // MARK: - Properties
      
    // MARK: - UI Components
    
    lazy var segementcontrol: UISegmentedControl = {
        let items = ["메뉴", "영양정보"]
        let sc = UISegmentedControl(items: items)
        sc.center = self.center
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        sc.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2
        sc.backgroundColor = .lightGray
        
        return sc}()
    
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

extension HeaderView {
    private func setUI() {

    }
    
    private func setLayout() {
        self.addSubview(segementcontrol)
        segementcontrol.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("메뉴")
        case 1:
            print("영양정보")
        default:
            break
        }
    }
}
