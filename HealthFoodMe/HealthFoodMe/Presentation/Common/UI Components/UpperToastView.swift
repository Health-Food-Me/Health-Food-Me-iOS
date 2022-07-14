//
//  UpperToastView.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import UIKit
import SnapKit

final class UpperToastView: UIView {
  
  var title: String = "" { didSet {
    titleLabel.text = title
  }}
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .NotoRegular(size: 13)
    label.textColor = .white
    return label
  }()
  
  private override init(frame: CGRect) {
      super.init(frame: frame)
  }
  
  convenience init(title: String) {
    self.init()
    setUI()
    self.titleLabel.text = title
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

extension UpperToastView {
  private func setUI() {
    self.backgroundColor = .init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
  }
}
