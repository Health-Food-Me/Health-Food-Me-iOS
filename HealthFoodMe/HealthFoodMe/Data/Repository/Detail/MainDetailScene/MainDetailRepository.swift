//
//  MainDetailRepository.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import RxSwift

protocol MainDetailRepository {
  
}

final class DefaultMainDetailRepository {
  
  private let disposeBag = DisposeBag()

  init() {
    
  }
}

extension DefaultMainDetailRepository: MainDetailRepository {
  
}
