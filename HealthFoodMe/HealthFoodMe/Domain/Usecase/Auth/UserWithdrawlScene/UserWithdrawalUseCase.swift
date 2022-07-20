//
//  UserWithdrawlUseCase.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift
import RxRelay

protocol UserWithdrawalUseCase {
  func getUserNickname()
  var userNickname: PublishRelay<String> { get set }
}

final class DefaultUserWithdrawlUseCase {
  
  private let repository: NicknameRepository
  private let disposeBag = DisposeBag()
  
  var userNickname = PublishRelay<String>()
  
  init(repository: NicknameRepository) {
    self.repository = repository
  }
}

extension DefaultUserWithdrawlUseCase: UserWithdrawalUseCase {
  func getUserNickname() {
      repository.getUserNickname()
      
      repository.userNickname
      .subscribe(onNext: { [weak self] nickname in
        guard let self = self else { return }
        self.userNickname.accept(nickname)
      }).disposed(by: self.disposeBag)
  }
}
