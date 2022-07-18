//
//  UserRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum UserRouter {
    case getScrapList(userId: String)
}

extension UserRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .getScrapList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getScrapList(let userId):
            return "/user/\(userId)/scrapList"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getScrapList:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getScrapList:
            return .withToken
        }
    }
}
