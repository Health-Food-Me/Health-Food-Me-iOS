//
//  SocialLoginVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/05.
//

import UIKit

import SnapKit

class SocialLoginVC: UIViewController {

    lazy var titleImageView = UIImageView()
    lazy var subtitleImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        titleImageView.image = UIImage(named: "authTitle")
        subtitleImageView.image = UIImage(named: "authSubtitle")
    }

}
