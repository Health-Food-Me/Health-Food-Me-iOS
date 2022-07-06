//
//  TabIndicator.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/06.
//

import UIKit

import SnapKit

final class TabIndicator: UIView {
    
    // MARK: Properties
    
    var widthRatio: Double? {
        didSet {
            guard let widthRatio = self.widthRatio else { return }
            self.trackTintView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(widthRatio)
                $0.left.greaterThanOrEqualToSuperview()
                $0.right.lessThanOrEqualToSuperview()
                self.leftInsetConstraint = $0.left.equalToSuperview().priority(999).constraint
            }
        }
    }
    
    var leftOffsetRatio: Double? {
        didSet {
            guard let leftOffsetRatio = self.leftOffsetRatio else { return }
            self.leftInsetConstraint?.update(inset: leftOffsetRatio * self.bounds.width)
        }
    }
    
    private var leftInsetConstraint: Constraint?

    // MARK: UI Components
    
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let trackTintView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // MARK: Initilize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension TabIndicator {
    private func setLayout() {
        self.addSubview(self.trackView)
        self.trackView.addSubview(self.trackTintView)
        
        trackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        trackTintView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0/5.0)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            self.leftInsetConstraint = make.left.equalToSuperview().priority(999).constraint
        }
    }
}
