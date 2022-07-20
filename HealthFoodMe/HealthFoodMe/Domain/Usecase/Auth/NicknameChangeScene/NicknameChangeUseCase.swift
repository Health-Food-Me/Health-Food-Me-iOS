//
//  ChangeNicknameUseCase.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift
import RxRelay

protocol NicknameChangeUseCase {
  func checkNicknameHasCharacter(nickname: String)

  var nicknameHasCharacter: PublishSubject<Bool> { get set }
  var nicknameChangeState: PublishSubject<NicknameChangeStatus> { get set }
}

final class DefaultNicknameChangeUseCase {
  
  private let repository: NicknameRepository
  private let disposeBag = DisposeBag()
  
  var nicknameHasCharacter = PublishSubject<Bool>()
  var nicknameChangeState = PublishSubject<NicknameChangeStatus>()

  init(repository: NicknameRepository) {
    self.repository = repository
  }
}

extension DefaultNicknameChangeUseCase: NicknameChangeUseCase {
  func checkNicknameHasCharacter(nickname: String) {
      if hasCharacter(nickname) {
          self.nicknameHasCharacter.onNext(true)
      } else {
          putNicknameChange(nickname: nickname)
      }
  }
  
  private func putNicknameChange(nickname: String) {
    repository.putNicknameChange(nickname: nickname)

    repository.userNicknameChange.subscribe(onNext: { [weak self] changeState in
        guard let self = self else { return }
        self.nicknameChangeState.onNext(changeState)
    }).disposed(by: self.disposeBag)
  }
  
  private func hasCharacter(_ nickname: String) -> Bool {
    let nicknameExceptSpacing = nickname.replacingOccurrences(of: " ", with: "")
    let nickRegEx = "[가-힣A-Za-z0-9]{1,12}"
    let pred = NSPredicate(format: "SELF MATCHES %@", nickRegEx)
    return !pred.evaluate(with: nicknameExceptSpacing)
  }
}
