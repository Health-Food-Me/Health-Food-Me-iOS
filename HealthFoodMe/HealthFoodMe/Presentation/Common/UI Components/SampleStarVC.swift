//
//  SampleStarVC.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/13.
//

import UIKit
import SnapKit

// StarRatingSlider 사용법을 나타내기 위해 만든 VC입니다.
// 참고후 삭제해주시면 감사하겠습니다 ! !
class SampleStarVC: UIViewController {
    let sliderView = StarRatingSlider(starWidth: 37)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sliderView)
        
        sliderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(185)
            make.height.equalTo(37)
        }
        
        sliderView.sliderValue = { point in
            print(point)
        }
    }
}
