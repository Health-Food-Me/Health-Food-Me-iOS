//
//  ChangeNickNameViewModel.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift
import RxRelay

final class NicknameChangeViewModel: ViewModelType {

  private let useCase: NicknameChangeUseCase
  private let disposeBag = DisposeBag()
  
  // MARK: - Inputs
  struct Input {
    let ctaButtonClickEvent: Observable<String?>
  }
  
  // MARK: - Outputs
  struct Output {
    let currentNicknameStatus = PublishRelay<NicknameChangeStatus>()
  }
  
  init(useCase: NicknameChangeUseCase) {
    self.useCase = useCase
  }
}

extension NicknameChangeViewModel {
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    self.bindOutput(output: output, disposeBag: disposeBag)
    // input,output 상관관계 작성
    
    input.ctaButtonClickEvent
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] nickname in
        guard let self = self else { return }
        self.useCase.checkNicknameHasCharacter(nickname: nickname!)
      }).disposed(by: self.disposeBag)
    
    return output
  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    let hasSpecialCharacter = useCase.nicknameHasCharacter
    let nicknameChangeState = useCase.nicknameChangeState
    
    hasSpecialCharacter
    .subscribe(onNext: { nicknameState in
        if !nicknameState {
            output.currentNicknameStatus.accept(.containsSpecialCharacter)
        }
    }).disposed(by: self.disposeBag)
      
    nicknameChangeState.subscribe(onNext: { [weak self] changeSuccess in
        if changeSuccess == .normal { output.currentNicknameStatus.accept(.normal) }
        else if changeSuccess == .duplicated { output.currentNicknameStatus.accept(.duplicated) }
        else { output.currentNicknameStatus.accept(.networkFail) }
    }).disposed(by: self.disposeBag)
  }
}

enum NicknameChangeStatus {
  case normal
  case duplicated
  case containsSpecialCharacter
  case networkFail
}
