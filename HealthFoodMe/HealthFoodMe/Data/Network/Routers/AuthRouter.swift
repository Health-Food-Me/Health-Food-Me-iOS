//
//  AuthRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum AuthRouter {
    case postSocialLogin(socialType: String, token: String)
    case reissuanceAccessToken
    case withdrawal(userId: String)
}

extension AuthRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .postSocialLogin:
            return .post
        case .withdrawal:
            return .delete
        default :
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .postSocialLogin:
            return "/auth"
        case .reissuanceAccessToken:
            return "/auth/token"
        case .withdrawal(let userId):
            return "/auth/withdrawal/\(userId)"
        default:
            return ""
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .postSocialLogin(let social, let token):
            let os = "iOS"
            let osVersion = UIDevice.iOSVersion
            let deviceInfo = UIDevice.iPhoneModel
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "errorVersion"

            let requestBody: [String: Any] = [
                "social": social,
                "token": token,
                "agent": [os, osVersion, deviceInfo, appVersion].joined(separator: ";")
            ]
            return .requestBody(requestBody)
        case .withdrawal(let userId):
            let requestParams: [String: Any] = [
                "userId": userId
            ]
            return .query(requestParams)
        default:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self {
        case .postSocialLogin:
            return .default
        case .reissuanceAccessToken:
            return .reissuance
        case .withdrawal:
            return .withToken
        default:
            return .withToken
        }
    }
}

