//
//  MainDetailUseCase.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import RxSwift

protocol MainDetailUseCase {

}

final class DefaultMainDetailUseCase {
  
  private let repository: MainDetailRepository
  private let disposeBag = DisposeBag()
  
  init(repository: MainDetailRepository) {
    self.repository = repository
  }
}

extension DefaultMainDetailUseCase: MainDetailUseCase {
  
}
