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
    case putUserNickname(userId: String, nickname: String)
    case deleteUser(userId: String)
}

extension UserRouter: BaseRouter {
    var method: HTTPMethod {
    switch self {
        case .getScrapList:
            return .get
        case .putScrap, .putUserNickname:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getScrapList(let userId):
            return "/user/\(userId)/scrapList"
        case .putScrap(let userId, let restaurantId):
            return "/user/\(userId)/scrap/\(restaurantId)"
        case .putUserNickname(let userID,_):
            return "/user/\(userID)/profile"
        case .deleteUser(let userID):
            return "/auth/withdrawal/\(userID)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getScrapList:
            return .requestPlain
        case .putScrap:
            return .requestPlain
        case .deleteUser:
            return .requestPlain
        case .putUserNickname(_,let nickname):
            let body: [String: Any] = [
                "name": nickname
            ]
            return .requestBody(body)
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getScrapList:
            return .withToken
        case .putScrap:
            return .withToken
        case .deleteUser:
            return .withToken
        case .putUserNickname:
            return .withToken
        }
    }
}
