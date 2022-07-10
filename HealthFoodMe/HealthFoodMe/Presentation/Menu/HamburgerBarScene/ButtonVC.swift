//
//  ButtonVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/10.
//

import UIKit
import SnapKit

class ButtonVC: UIViewController {

    private lazy var hamburgerBarButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setUI()
    }

}

extension ButtonVC {
    private func setUI() {
        hamburgerBarButton.setTitleColor(.helfmeBlack, for: .normal)
        hamburgerBarButton.setTitle("햄버거바", for: .normal)
    }
    
    private func setLayout() {
        view.addSubview(hamburgerBarButton)
        
        hamburgerBarButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
    }
}
