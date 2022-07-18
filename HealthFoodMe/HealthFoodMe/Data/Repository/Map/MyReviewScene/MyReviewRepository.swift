//
//  MyReviewRepository.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import RxSwift

protocol MyReviewRepository {
  
}

final class DefaultMyReviewRepository {
  
    private let disposeBag = DisposeBag()

    init() {
    
    }
}

extension DefaultMyReviewRepository: MyReviewRepository {
  
}
