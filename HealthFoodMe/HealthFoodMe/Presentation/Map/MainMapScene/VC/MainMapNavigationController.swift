//
//  MainMapNavigationController.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/17.
//

import UIKit

class MainMapNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = makeMainMapVC()
        vc.checkLocationStatus()
        pushViewController(vc, animated: true)
        

    }
    
    
    func makeMainMapVC() -> MainMapVC {
        let repository = DefaultMainMapRepository()
        let useCase = DefaultMainMapUseCase(repository: repository)
        let viewModel = MainMapViewModel(useCase: useCase)
        let vc = MainMapVC.controllerFromStoryboard(.mainMap)
        vc.viewModel = viewModel
        
        return vc
    }
}
