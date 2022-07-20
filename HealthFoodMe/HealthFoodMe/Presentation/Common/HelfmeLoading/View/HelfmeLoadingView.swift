//
//  HelfmeLoadingVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/20.
//

import UIKit

import Lottie
import SnapKit

class HelfmeLoadingVC: UIView {
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.alpha = 0
        return view
    }()
    
    private var loadingView: AnimationView = {
        let animationView = AnimationView(name: "loading_iOS")
        animationView.loopMode = .loop
        
        return animationView
    }()
}

extension HelfmeLoadingVC {
    private func setLayout() {
        self.addSubview(contentView)
        contentView.addSubview(loadingView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(300)
        }
    }
    
    func show() {
        guard !AppDelegate.window.subviews.contains(where: {$0 is HelfmeLoadingVC})
        self.layoutIfNeeded()
        self.loadingView.play()
    }
    
    func hide(completion: @escaping () -> ()) {
        self.loadingView.stop()
        self.removeFromSuperview()
        completion()
    }
}
