//
//  HelfmeLoadingVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/20.
//

import UIKit

import Lottie
import SnapKit

class HelfmeLoadingView: UIView {
    
    // MARK: - Properties
    
    static let shared = HelfmeLoadingView()
    
    // MARK: - UI Components
    
    private var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loading_iOS")
        animationView.loopMode = .loop
        
        return animationView
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension HelfmeLoadingView {
    private func setLayout() {
        self.addSubview(contentView)
        contentView.addSubview(self.loadingView)

        self.contentView.snp.makeConstraints {
          $0.center.equalTo(self.safeAreaLayoutGuide)
        }
        self.loadingView.snp.makeConstraints {
          $0.center.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setUI() {
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.last else { return }
        print("윈도우", window)
        window.addSubview(self)
        
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        self.loadingView.play()
            UIView.animate(
              withDuration: 0.7,
              animations: { self.contentView.alpha = 1 }
            )
    }
    
    func hide(completion: @escaping () -> ()) {
        self.loadingView.stop()
        self.removeFromSuperview()
        completion()
    }
}
