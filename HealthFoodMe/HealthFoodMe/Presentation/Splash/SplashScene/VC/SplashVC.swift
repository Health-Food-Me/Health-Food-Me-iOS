//
//  SplashVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/17.
//

import UIKit

import Lottie

class SplashVC: UIViewController {
  
    // MARK: - UI Components
    
    private let animationView: AnimationView = .init(name: "splash_ios")
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        playAnimation()
        presentToMainMap()
    }
}

// MARK: - Methods

extension SplashVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubview(animationView)

        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
    }
    
    private func playAnimation() {
        animationView.play()
    }
    
    private func presentToMainMap() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            let vc = ModuleFactory.resolve().makeMainMapVC()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Network

extension SplashVC {

}
