//
//  SplashVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/17.
//

import UIKit

import Lottie

class SplashVC: UIViewController {
    
    // MARK: - Properties
    
    let userManager = UserManager.shared
    
    // MARK: - UI Components
    
    private let animationView: AnimationView = .init(name: "splash_ios")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        playAnimation()
        checkLoginStatusAndPresentVC()
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
    
    private func presentMainMapVC() {
        let vc = ModuleFactory.resolve().makeMainMapVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false)
    }
    
    private func presentSocialLoginVC() {
        let vc = ModuleFactory.resolve().makeLoginVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    private func checkLoginStatusAndPresentVC() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            if self.userManager.isLogin == true {
                self.reissuanceToken()
            } else {
                self.presentSocialLoginVC()
            }
        }
    }
}

// MARK: - Network

extension SplashVC {
    private func reissuanceToken() {
        userManager.reissuanceAccessToken() { success in
            if success {
                self.presentMainMapVC()
            } else {
                self.presentSocialLoginVC()
            }
        }
    }
}
