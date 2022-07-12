//
//  MainMapUseCase.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import RxSwift

protocol MainMapUseCase {

}

final class DefaultMainMapUseCase {
  
    private let repository: MainMapRepository
    private let disposeBag = DisposeBag()
  
    init(repository: MainMapRepository) {
        self.repository = repository
    }
}

extension DefaultMainMapUseCase: MainMapUseCase {
  
}
