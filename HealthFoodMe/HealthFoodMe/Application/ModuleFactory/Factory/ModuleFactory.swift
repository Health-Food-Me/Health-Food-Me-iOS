//
//  ModuleFactory.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

protocol ModuleFactoryProtocol {
    
    // MARK: - Map
    func instantiateMainMapVC() -> MainMapVC
    
    // MARK: - Detail
    func instantiateMainDetailVC() -> MainDetailVC
}

class ModuleFactory: ModuleFactoryProtocol {
    
    static func resolve() -> ModuleFactory {
        return ModuleFactory()
    }
    
    // MARK: - Map
    func instantiateMainMapVC() -> MainMapVC {
        let repository = DefaultMainMapRepository()
        let useCase = DefaultMainMapUseCase(repository: repository)
        let viewModel = MainMapViewModel(useCase: useCase)
        let vc = MainMapVC.controllerFromStoryboard(.mainMap)
        vc.viewModel = viewModel
        
        return vc
    }
    
    // MARK: - Detail
    func instantiateMainDetailVC() -> MainDetailVC {
        let repository = DefaultMainDetailRepository()
        let useCase = DefaultMainDetailUseCase(repository: repository)
        let viewModel = MainDetailViewModel(useCase: useCase)
        let vc = MainDetailVC.controllerFromStoryboard(.mainDetail)
        vc.viewModel = viewModel
        
        return vc
    }
    
    // MARK: - Plan
    
//    func instantiatePlanPreviewVC(postID: Int) -> PlanPreviewVC {
//        let repository = DefaultPlanPreviewRepository(service: BaseService.default)
//        let useCase = DefaultPlanPreviewUseCase(repository: repository, postIdx: postID)
//        let viewModel = PlanPreviewViewModel(useCase: useCase)
//        let vc = PlanPreviewVC.controllerFromStoryboard(.planPreview)
//        vc.viewModel = viewModel
//
//        return vc
//    }
    
}
