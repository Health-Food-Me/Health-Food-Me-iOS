//
//  ChangeNicknameRepository.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/14.
//

import RxSwift

protocol NicknameChangeRepository {
  func postNicknameInValidCheck(nickname: String) -> Observable<Bool?>
}

// FIXME: - 실제 네트워크 나오면 바로 Service 프로토콜 주입 및 파일 붙일 예정
final class DefaultNicknameChangeRepository {
  
//  private let networkService: AuthServiceType
  private let disposeBag = DisposeBag()

//  init(service: AuthServiceType) {
//    self.networkService = service
//  }
}

extension DefaultNicknameChangeRepository: NicknameChangeRepository {
  func postNicknameInValidCheck(nickname: String) -> Observable<Bool?> {
    //  return self.networkService.checkNicknameDuplicated(nickname: nickname)
    //  이후 실제로 쓸 코드 잠시 주석처리 해둠 (서버 되면 붙일 예정)
    
    // 닉네임 중복 검사를 잠시 임시로 처리해둠
    return .create { observer in
      if nickname == "중복된닉네임" || nickname == "중복" {
        observer.onNext(true)
      }else {
        observer.onNext(false)
      }
      return Disposables.create()
    }
  }
}
