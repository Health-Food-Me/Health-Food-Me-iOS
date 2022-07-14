//
//  ChangeNicknameUseCase.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift
import RxRelay

protocol ChangeNicknameUseCase {
  func checkNicknameHasCharacter(nickname: String)
  func checkNicknameDuplicated(nickname: String)

  var nicknameDuplicated: PublishSubject<Bool> { get set }
  var nicknameHasCharacter: PublishSubject<Bool> { get set }
}

final class DefaultChangeNicknameUseCase {
  
  private let repository: ChangeNicknameRepository
  private let disposeBag = DisposeBag()
  
  var nicknameDuplicated = PublishSubject<Bool>()
  var nicknameHasCharacter = PublishSubject<Bool>()

  init(repository: ChangeNicknameRepository) {
    self.repository = repository
  }
}

extension DefaultChangeNicknameUseCase: ChangeNicknameUseCase {
  func checkNicknameHasCharacter(nickname: String) {
    self.nicknameHasCharacter.onNext(hasCharacter(nickname))
  }
  
  func checkNicknameDuplicated(nickname: String) {
    repository.postNicknameInValidCheck(nickname: nickname)
      .filter { $0 != nil }

      .subscribe(onNext: { [weak self] duplicated in
      guard let self = self else { return }
        print("USECASE 에서 중복 체크해줌")
      self.nicknameDuplicated.onNext(duplicated!)
    }).disposed(by: self.disposeBag)
    
  }
  
  private func hasCharacter(_ nickname: String) -> Bool {
    let nickRegEx = "[가-힣A-Za-z0-9\\s]{20}"
    let pred = NSPredicate(format: "SELF MATCHES %@", nickRegEx)
    return !pred.evaluate(with: nickname)
  }
}
