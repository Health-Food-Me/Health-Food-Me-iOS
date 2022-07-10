//
//  StarRatingView.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/11.
//

import UIKit

import SnapKit

final class StarRatingView: UIView {
    
    // MARK: - Properties
    
    var spacing: CGFloat = 2 {
        didSet {
            starStackView.spacing = self.spacing
        }
    }
    
    var rate: CGFloat = 0 {
        didSet {
            paintStars()
        }
    }
    
    private var starImageViews: [UIImageView] = []
    
    private var starScale: CGFloat = 50
    
    // MARK: - UI Components
    
    private lazy var starStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = self.spacing
        st.distribution = .fillProportionally
        return st
    }()
    
    // MARK: View Life Cycle
    
    convenience init(starScale: CGFloat) {
        self.init()
        
        self.starScale = starScale
        setUI()
        setLayout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension StarRatingView {
   
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.addSubviews(starStackView)
        
        setStarStackView()
        starStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setStarStackView() {
        for starNumber in 0...4 {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.starScale, height: self.starScale))
            imageView.contentMode = .scaleToFill
            imageView.image = ImageLiterals.Common.starIcon
            imageView.tag = starNumber
            starImageViews.append(imageView)
            starStackView.addArrangedSubviews(imageView)
        }
    }
    
    func paintStars() {
        starImageViews.forEach { star in
            let starTag = CGFloat(star.tag) - 0.001
            
            if starTag <= rate - 1 {
                star.image = ImageLiterals.Common.starIcon_filled
            } else {
                if starTag < rate - 0.9 {
                    star.image = ImageLiterals.Common.starIcon_filled
                } else if starTag <= rate - 0.6 {
                    star.image = ImageLiterals.Common.starIcon_75
                } else if starTag < rate - 0.4 {
                    star.image = ImageLiterals.Common.starIcon_50
                } else if starTag <= rate - 0.1 {
                    star.image = ImageLiterals.Common.starIcon_25
                } else {
                    star.image = ImageLiterals.Common.starIcon
                }
            }
        }
    }
}
