//
//  UserRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum UserRouter {
    case getScrapList(userId: String)
    case putScrap(userId: String, restaurantId: String)
}

extension UserRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .getScrapList:
            return .get
        case .putScrap:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .getScrapList(let userId):
            return "/user/\(userId)/scrapList"
        case .putScrap(let userId, let restaurantId):
            return "/user/\(userId)/scrap/\(restaurantId)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getScrapList:
            return .requestPlain
        case .putScrap:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getScrapList:
            return .withToken
        case .putScrap:
            return .withToken
        }
    }
}
