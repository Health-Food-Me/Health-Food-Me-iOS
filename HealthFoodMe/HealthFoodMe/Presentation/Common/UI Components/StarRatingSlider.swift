//
//  StarRatingSlider.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/13.
//

import UIKit
import SnapKit

final class StarRatingSlider: UIView {
  
  // MARK: - Properties
  private var previousValue: CGFloat = -1
  private var starWidth: CGFloat = 37
  var initialValue: Double = 2.5
  var sliderValue : ( (Double) -> Void )?

  // MARK: - UI Components

  lazy var starRateSlider: TouchableSlider = {
    let slider = TouchableSlider()
    slider.backgroundColor = .clear
    slider.tintColor = .clear
    slider.thumbTintColor = .clear
    slider.maximumTrackTintColor = .clear
    slider.minimumTrackTintColor = .clear
    slider.minimumValue = 0
    slider.maximumValue = 5
    slider.value = 0
    slider.addTarget(self,
                     action: #selector(sliderValueChanged),
                     for: .valueChanged)
    return slider
  }()
  
  lazy var starContainerView: StarRatingView = {
    let starView = StarRatingView.init(starScale: starWidth)
    starView.rate = initialValue
    return starView
  }()
  
  private override init(frame: CGRect) {
      super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(starWidth: CGFloat) {
    self.init()
    self.starWidth = starWidth
    setUI()
  }
}

extension StarRatingSlider {
  private func setUI() {
    addSubviews(starContainerView, starRateSlider)
    starContainerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    starRateSlider.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    starContainerView.rate = initialValue
  }
    
    func setSliderValue(rate: Double) {
        starContainerView.rate = rate
    }
}

extension StarRatingSlider {
  @objc func sliderValueChanged(_ slider: UISlider) {
    let pointValue = getPointValue(slider.value)
    if previousValue != pointValue {
      makeVibrate()
      sliderValue?(Double(pointValue))
      previousValue = pointValue
    }
    print(pointValue)
    starContainerView.rate = CGFloat(pointValue)
  }
  
  private func getPointValue(_ value: Float) -> CGFloat {
    guard value > 0 else { return 0}
    if value >= 5 { return 5 }
    let intValue = Float(Int(value))
    let decimalValue = value - intValue
    
    switch(decimalValue) {
      case 0 ..< 0.25: return CGFloat(intValue)
      case 0.25 ..< 0.75: return CGFloat(intValue) + 0.5
      default: return CGFloat(intValue) + 1.0
    }
  }
}
