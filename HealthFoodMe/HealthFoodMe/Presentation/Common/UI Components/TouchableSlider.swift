//
//  TouchableSlider.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/13.
//

import UIKit
// 기존 슬라이더에서는 터치로 값을 변경할 수 없었는데,
// 터치값으로 value를 변경하기 위해 새로운 클래스 생성

final class TouchableSlider: UISlider {
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let conversion = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(conversion, animated: false)
        sendActions(for: .allTouchEvents) //Add this because without this it won't work.
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    print("TOUCH")
    let width = self.frame.size.width
    let tapPoint = touch.location(in: self)
    let fPercent = tapPoint.x/width
    let nNewValue = self.maximumValue * Float(fPercent)
    if nNewValue != self.value {
      self.value = nNewValue
    }
    return true
  }
}

extension UISlider {
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        print("HELLO")
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: true)
        sendActions(for: .valueChanged)
    }
}
