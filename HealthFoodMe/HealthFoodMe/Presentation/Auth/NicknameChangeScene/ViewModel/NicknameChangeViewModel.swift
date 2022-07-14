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
    let currentNicknameStatus = PublishRelay<NicknameStatus>()
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
        self.useCase.checkNicknameDuplicated(nickname: nickname!)
      }).disposed(by: self.disposeBag)
    
    return output
  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    let hasSpecialCharacter = useCase.nicknameHasCharacter
    let isDuplicatedNickname = useCase.nicknameDuplicated
    
    Observable.combineLatest(hasSpecialCharacter, isDuplicatedNickname,
                             resultSelector: { characterState, duplicatedState -> NicknameStatus in
      if characterState { return NicknameStatus.containsSpecialCharacter }
      else if duplicatedState { return NicknameStatus.duplicated }
      else { return NicknameStatus.normal}
    })
    .subscribe(onNext: { [weak self] nicknameState in
      output.currentNicknameStatus.accept(nicknameState)
    }).disposed(by: self.disposeBag)
  }
}

enum NicknameStatus {
  case normal
  case duplicated
  case containsSpecialCharacter
}
