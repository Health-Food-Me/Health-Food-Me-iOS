//
//  UserWithdrawlViewModel.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift
import RxRelay

final class UserWithdrawalViewModel: ViewModelType {

  private var userNickname: String?
  private let useCase: UserWithdrawalUseCase
  private let disposeBag = DisposeBag()
  
  // MARK: - Inputs
  struct Input {
    let viewWillAppearEvent: Observable<Void?>
    let userInputText: Observable<String?>
  }
  
  // MARK: - Outputs
  struct Output {
    let userNickname = PublishRelay<String?>()
    let isMatchNickname = PublishRelay<Bool?>()
  }
  
  init(useCase: UserWithdrawalUseCase) {
    self.useCase = useCase
  }
}

extension UserWithdrawalViewModel {
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    self.bindOutput(output: output, disposeBag: disposeBag)
    input.viewWillAppearEvent
      .subscribe(onNext: { _ in
        self.useCase.getUserNickname()
      }).disposed(by: self.disposeBag)
    
    input.userInputText
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] inputText in
        guard let self = self else { return }
        output.isMatchNickname.accept(inputText! == self.userNickname)
      }).disposed(by: self.disposeBag)
    
    return output
  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    let userNicknameRelay = useCase.userNickname
    
    userNicknameRelay
      .subscribe(onNext: { nickname in
        self.userNickname = nickname
        output.userNickname.accept(nickname)
      }).disposed(by: self.disposeBag)
  }
}
