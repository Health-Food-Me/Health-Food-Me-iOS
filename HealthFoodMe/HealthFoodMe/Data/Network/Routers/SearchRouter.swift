//
//  SearchRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum SearchRouter {
    case requestRestaurantSearch(query: String)
    case postSocialLogin(socialType: String, token: String)
}

extension SearchRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .requestRestaurantSearch:
            return .get
        case .postSocialLogin:
            return .post
        default :
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .requestRestaurantSearch:
            return "/restaurant/search"
        case .postSocialLogin(_, let token):
            return "/auth"
        default:
            return ""
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .requestRestaurantSearch(let query):
            let requestQuery: [String: Any] = [
                "query": query
            ]
            return .query(requestQuery)
        case .postSocialLogin(let socialType, let token):
            let requestBody: [String: Any] = [
                "social": socialType,
                "token": token
            ]
            return .requestBody(requestBody)
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
