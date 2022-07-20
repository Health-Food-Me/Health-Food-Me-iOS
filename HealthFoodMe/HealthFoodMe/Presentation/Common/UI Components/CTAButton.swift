//
//  CTAButton.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import UIKit

final class CTAButton: UIButton {

  convenience init(enableState: Bool,title: String) {
    self.init()
    setUI()
    self.isEnabled = enableState
    self.setTitle(title, for: .normal)
    let titleAttributedString = NSAttributedString(string: title,
                                                   attributes:
                                                    [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                    NSAttributedString.Key.font : UIFont.NotoBold(size: 15)])
    self.setAttributedTitle(titleAttributedString, for: .normal)
  }
  
  private override init(frame: CGRect) {
      super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.setBackgroundColor(UIColor.helfmeTagGray, for: .disabled)
    self.setBackgroundColor(UIColor.mainRed, for: .normal)
  }
    
    func setAttributedTitleForDisabled(title: String) {
        let titleAttributedString = NSAttributedString(string: title,
                                                       attributes:
                                                        [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                        NSAttributedString.Key.font : UIFont.NotoBold(size: 15)])
        self.setAttributedTitle(titleAttributedString, for: .disabled)
    }
}
