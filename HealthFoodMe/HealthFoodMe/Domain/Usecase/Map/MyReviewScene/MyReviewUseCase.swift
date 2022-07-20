//
//  MyReviewUseCase.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import RxSwift

protocol MyReviewUseCase {

}

final class DefaultMyReviewUseCase {
  
    private let repository: MyReviewRepository
    private let disposeBag = DisposeBag()
  
    init(repository: MyReviewRepository) {
        self.repository = repository
    }
}

extension DefaultMyReviewUseCase: MyReviewUseCase {
  
}
