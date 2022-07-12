//
//  MainMapRepository.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import RxSwift

protocol MainMapRepository {
  
}

final class DefaultMainMapRepository {
  
    private let disposeBag = DisposeBag()

    init() {
    
    }
}

extension DefaultMainMapRepository: MainMapRepository {
  
}
