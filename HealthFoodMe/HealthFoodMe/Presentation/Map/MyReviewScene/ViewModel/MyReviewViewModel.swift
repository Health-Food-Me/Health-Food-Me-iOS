//
//  MyReviewViewModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import RxSwift

final class MyReviewViewModel: ViewModelType {

    private let useCase: MyReviewUseCase
    private let disposeBag = DisposeBag()
  
    // MARK: - Inputs
    
    struct Input {
    
    }
  
    // MARK: - Outputs
    
    struct Output {
    
    }
  
    init(useCase: MyReviewUseCase) {
        self.useCase = useCase
    }
}

extension MyReviewViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
    
    }
}
