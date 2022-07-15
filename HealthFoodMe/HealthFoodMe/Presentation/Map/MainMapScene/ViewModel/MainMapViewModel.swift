//
//  MainMapViewModel.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import RxSwift
import RxRelay

final class MainMapViewModel: ViewModelType {

    private let useCase: MainMapUseCase
    private let disposeBag = DisposeBag()
  
    // MARK: - Inputs
    
    struct Input {
        let myLocationButtonTapped: Observable<Void>
        let scrapButtonTapped: Observable<Void>
    }
  
    // MARK: - Outputs
    
    struct Output {
        var moveToMyLocation = PublishRelay<String>()
    }
  
    init(useCase: MainMapUseCase) {
        self.useCase = useCase
    }
}

extension MainMapViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
    
    }
}
