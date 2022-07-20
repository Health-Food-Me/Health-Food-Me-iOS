//
//  ModuleFactory.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

protocol ModuleFactoryProtocol {
    
    // MARK: - Auth
    func makeLoginVC() -> SocialLoginVC
    func makeNicknameChangeVC() -> NicknameChangeVC
    func makeUserWithdrawlVC() -> UserWithdrawalVC

    // MARK: - Map
    func makeMainMapVC() -> MainMapVC
    func makeHamburgerBarVC() -> HamburgerBarVC
    func makeHamburgerBarNavigationController() -> HamburgerBarNavigationController
    func makeSupplementMapVC(forSearchVC: Bool) -> SupplementMapVC
    func makeMyReviewVC() -> MyReviewVC
    
    // MARK: - Detail
    func makeMainDetailVC() -> MainDetailVC
    func makeMenuTabVC() -> MenuTabVC
    func makeCopingTabVC() -> CopingTabVC
    func makeReviewDetailVC() -> ReviewDetailVC
    func makeReviewWriteVC() -> ReviewWriteVC
    func makeReviewWriteNavigationController() -> ReviewWriteNavigationController
    
    // MARK: - Search
    func makeSearchVC() -> SearchVC
    func makeSearchResultVC() -> SearchResultVC
    
    // MARK: - Scrap
    func makeScrapVC() -> ScrapVC
    
    // MARK: - Spalsh
    func makeSplashVC() -> SplashVC
    // MARK: - Setting
    func makeSettingVC() -> SettingVC
}

class ModuleFactory: ModuleFactoryProtocol {

    static func resolve() -> ModuleFactory {
        return ModuleFactory()
    }
  
    // MARK: - Auth
    func makeLoginVC() -> SocialLoginVC {
        let vc = SocialLoginVC.controllerFromStoryboard(.socialLogin)
        return vc
    }
    
    func makeNicknameChangeVC() -> NicknameChangeVC {
        let repository = DefaultNicknameRepository()
        let useCase = DefaultNicknameChangeUseCase(repository: repository)
        let viewModel = NicknameChangeViewModel(useCase: useCase)
        let vc = NicknameChangeVC.controllerFromStoryboard(.nicknameChange)
        vc.viewModel = viewModel
        
        return vc
    }
    
    func makeUserWithdrawlVC() -> UserWithdrawalVC {
        let repository = DefaultNicknameRepository()
        let useCase = DefaultUserWithdrawlUseCase(repository: repository)
        let viewModel = UserWithdrawalViewModel(useCase: useCase)
        let vc = UserWithdrawalVC.controllerFromStoryboard(.userWithdrawal)
        vc.viewModel = viewModel
        
        return vc
    }
    
    func makeReviewWriteVC() -> ReviewWriteVC {
        let vc = ReviewWriteVC.controllerFromStoryboard(.reviewWrite)

        return vc
    }


    
    // MARK: - Map
    func makeMainMapNavigationController() -> MainMapNavigationController {
        print("")
        return MainMapNavigationController.controllerFromStoryboard(.mainMap)
    }
    
    func makeMainMapVC() -> MainMapVC {
        let repository = DefaultMainMapRepository()
        let useCase = DefaultMainMapUseCase(repository: repository)
        let viewModel = MainMapViewModel(useCase: useCase)
        let vc = MainMapVC.controllerFromStoryboard(.mainMap)
        vc.viewModel = viewModel
        
        return vc
    }
    func makeHamburgerBarNavigationController() -> HamburgerBarNavigationController {
        let nc = HamburgerBarNavigationController.controllerFromStoryboard(.hamburgerBar)
        return nc
    }

    
    func makeHamburgerBarVC() -> HamburgerBarVC {
        let vc = HamburgerBarVC.controllerFromStoryboard(.hamburgerBar)
        
        return vc
    }
    
    func makeSupplementMapVC(forSearchVC: Bool) -> SupplementMapVC {
        var vc = SupplementMapVC(mapType: .scrap)
        if forSearchVC {
            vc = SupplementMapVC(mapType: .search)
        }
        
        return vc
    }
    
    func makeMyReviewVC() -> MyReviewVC {
        let repository = DefaultMyReviewRepository()
        let useCase = DefaultMyReviewUseCase(repository: repository)
        let viewModel = MyReviewViewModel(useCase: useCase)
        let vc = MyReviewVC.controllerFromStoryboard(.myReview)
        vc.viewModel = viewModel
        
        return vc
    }
    
    // MARK: - Detail
    func makeMainDetailVC() -> MainDetailVC {
        let repository = DefaultMainDetailRepository()
        let useCase = DefaultMainDetailUseCase(repository: repository)
        let viewModel = MainDetailViewModel(useCase: useCase)
        let vc = MainDetailVC.controllerFromStoryboard(.mainDetail)
        vc.viewModel = viewModel
        
        return vc
    }
    
    func makeMenuTabVC() -> MenuTabVC {
        let vc = MenuTabVC.controllerFromStoryboard(.menuTab)
        
        return vc
    }
    
    func makeCopingTabVC() -> CopingTabVC {
        let vc = CopingTabVC.controllerFromStoryboard(.copingTab)
        
        return vc
    }
    
    func makeReviewWriteNavigationController() -> ReviewWriteNavigationController {
        let nc = ReviewWriteNavigationController.controllerFromStoryboard(.reviewWrite)
        
        return nc
    }
    
    func makeReviewDetailVC() -> ReviewDetailVC {
        let vc = ReviewDetailVC.controllerFromStoryboard(.reviewDetail)
        
        return vc
    }
    
    // MARK: - Search
    func makeSearchVC() -> SearchVC {
        let vc = SearchVC.controllerFromStoryboard(.search)
        
        return vc
    }
    
    func makeSearchResultVC() -> SearchResultVC {
        let vc = SearchResultVC.controllerFromStoryboard(.searchResult)
        
        return vc
    }
    
    // MARK: - Scrap
    func makeScrapVC() -> ScrapVC {
        let vc = ScrapVC.controllerFromStoryboard(.scrap)
        
        return vc
    }
    
    // MARK: - HelfmeAlert
    func makeHelfmeAlertVC() -> HelfmeAlertVC {
        let vc = HelfmeAlertVC.controllerFromStoryboard(.helfmeAlert)
        
        return vc
    }
    
    func makeSplashVC() -> SplashVC {
        let vc = SplashVC.controllerFromStoryboard(.splash)
        
        return vc
    }
    // MARK: - Setting
    func makeSettingVC() -> SettingVC {
        return SettingVC.controllerFromStoryboard(.setting)
    }

    // MARK: - Plan
    
}
