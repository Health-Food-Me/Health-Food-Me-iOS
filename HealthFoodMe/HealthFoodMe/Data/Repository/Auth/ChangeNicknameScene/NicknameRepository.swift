//
//  ChangeNicknameRepository.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift

protocol NicknameRepository {
  func putNicknameChange(nickname: String)
  func getUserNickname()
    
  var userNicknameChange: PublishSubject<NicknameChangeStatus> { get set }
  var userNickname: PublishSubject<String> { get set }
}

// FIXME: - 실제 네트워크 나오면 바로 Service 프로토콜 주입 및 파일 붙일 예정
final class DefaultNicknameRepository {
  
    var userNicknameChange = PublishSubject<NicknameChangeStatus>()
    var userNickname = PublishSubject<String>()
    private let networkService = UserService.shared
    private let disposeBag = DisposeBag()
}

extension DefaultNicknameRepository: NicknameRepository {
  func putNicknameChange(nickname: String) {
      guard let userId = UserManager.shared.getUser else { return }
      networkService.putUserNickname(userId: userId,
                                     nickname: nickname) { result in
          switch(result)
          {
              case .success(_): self.userNicknameChange.onNext(.normal)
              case .requestErr(_): self.userNicknameChange.onNext(.duplicated)
              default : self.userNicknameChange.onNext(.networkFail)
          }
      }
  }
    
  func getUserNickname() {
      guard let userID = UserManager.shared.getUser else { return }
      UserService.shared.getUserNickname(userId: userID) { result in
          switch(result) {
              case .success(let result):
                  guard let result = result as? UserEntity else { return }
                  self.userNickname.onNext(result.name)
              default: break
          }
      }
  }
}
