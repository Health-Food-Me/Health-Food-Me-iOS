//
//  AuthService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

class AuthService: BaseService {
    static let shared = AuthService()
    
    private override init() {}
}

extension AuthService {
    func requestAuth(social: String, token: String,
                     completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(AuthRouter.postSocialLogin(socialType: social, token: token), type: SocialLoginEntity.self, decodingMode: .model, completion: completion)
    }
    
    func reissuanceAccessToken(completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(AuthRouter.reissuanceAccessToken, type: ReissunaceEntity.self, decodingMode: .model, completion: completion)
    }
    
    func withdrawalAuth(userId: String,
                        completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(AuthRouter.withdrawal(userId: userId),
                      type: withdrawalEntity.self,
                      decodingMode: .general,
                      completion: completion)
    }
}
