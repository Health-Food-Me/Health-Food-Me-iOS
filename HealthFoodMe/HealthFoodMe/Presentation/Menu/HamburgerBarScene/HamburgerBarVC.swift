//
//  HamburgerBarVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/10.
//

import UIKit

class HamburgerBarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        let blackColorWithAlpha: UIColor = UIColor(.black).withAlphaComponent(0.6)
        view.backgroundColor = blackColorWithAlpha
    }
}
