//
//  AuthRouter.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/21.
//

import Foundation
import Alamofire

enum AuthRouter {
    case requestSignUp(email: String, name: String, pw: String)
    case requestSignIn(email: String, pw: String)
    case requestPostData(postId: Int)
}

extension AuthRouter: BaseRouter {
    
    var path: String {
        switch self {
        case .requestSignUp:
            return "/auth/signup"
        case .requestSignIn:
            return "/auth/signin"
        case .requestPostData(let postId):
            return "/post/\(postId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestSignUp, .requestSignIn:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .requestSignUp(let email, let name, let pw):
            let body: [String : Any] = [
                "email": email,
                "name": name,
                "password": pw
            ]
            return .requestBody(body)
        case .requestSignIn(let email, let pw):
            let body: [String : Any] = [
                "email": email,
                "password": pw
            ]
            return .requestBody(body)
        default:
            return .requestPlain
        }
    }
}
