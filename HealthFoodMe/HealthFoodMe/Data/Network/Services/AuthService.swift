//
//  AuthService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

import Alamofire

class AuthService: BaseService {
    static let shared = AuthService()
    
    private override init() {}
}

extension AuthService {
    
    func requestSignIn(email: String, pw: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        AFManager.request(AuthRouter.requestSignIn(email: email, pw: pw)).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return}
                let networkResult = self.judgeStatus(by: statusCode, data, type: SignIn.self, decodingMode: .message)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func requestSignUp(email: String, name: String, pw: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        AFManager.request(AuthRouter.requestSignUp(email: email, name: name, pw: pw)).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return}
                let networkResult = self.judgeStatus(by: statusCode, data, type: SignUp.self, decodingMode: .message)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
