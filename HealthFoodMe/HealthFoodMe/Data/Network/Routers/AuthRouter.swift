//
//  AuthRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum AuthRouter {
    case postSocialLogin(socialType: String, token: String)
}

extension AuthRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .postSocialLogin:
            return .post
        default :
            return .get
        }
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    var parameters: RequestParams {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var hedaer: HeaderType {
        switch self {
        case .postSocialLogin:
            return .default
        default:
            return .withToken
        }
    }
}

