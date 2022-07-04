//
//  ModuleFactory.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

protocol ModuleFactoryProtocol {
    
    // MARK: - Auth
    //    func instantiateLoginVC() -> PostDetailVC
}

class ModuleFactory: ModuleFactoryProtocol{
    
    static func resolve() -> ModuleFactory {
        return ModuleFactory()
    }
    
    // MARK: - Auth
    //    func instantiateLoginVC() -> PostDetailVC {
    //        return PostDetailVC.controllerFromStoryboard(.postDetail)
    //    }
    
    // MARK: - Base Tap
    
    //  func instantiateBaseNC() -> BaseNC {
    //    return BaseNC.controllerFromStoryboard(.base)
    //  }
    //
    //  func instantiateBaseVC() -> BaseVC {
    //    return BaseVC.controllerFromStoryboard(.base)
    //  }
    
    // MARK: - Payment
    
    //  func instantiatePaymentSelectVC(paymentData: PaymentContentData) -> PaymentSelectVC {
    //    let vc = PaymentSelectVC.controllerFromStoryboard(.payment)
    //    vc.paymentData = paymentData
    //    return vc
    //  }
    
    // MARK: - Plan
    
    //  func instantiatePlanPreviewVC(postID: Int) -> PlanPreviewVC {
    //    let repository = DefaultPlanPreviewRepository(service: BaseService.default)
    //    let useCase = DefaultPlanPreviewUseCase(repository: repository, postIdx: postID)
    //    let viewModel = PlanPreviewViewModel(useCase: useCase)
    //    let vc = PlanPreviewVC.controllerFromStoryboard(.planPreview)
    //    vc.viewModel = viewModel
    //
    //    return vc
    //  }
    //
    //  func instantiatePlanDetailVC(postID: Int,isPreviewPage: Bool = false) -> PlanDetailVC {
    //
    //    let repository = PlanDetailRepository(service: BaseService.default)
    //    let viewModel = PlanDetailViewModel(postId: postID,
    //                                        isPreviewPage: isPreviewPage,
    //                                        repository: repository)
    //    let vc = PlanDetailVC.controllerFromStoryboard(.planDetail)
    //    vc.viewModel = viewModel
    //    return vc
    //  }
    
}
