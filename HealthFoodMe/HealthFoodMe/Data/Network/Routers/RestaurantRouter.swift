//
//  RestaurantRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum RestaurantRouter {
    case requestRestaurantSearch(query: String)
    case fetchRestaurantSummary(restaurantId: String, userId: String)
}

extension RestaurantRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .requestRestaurantSearch:
            return .get
        default :
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .requestRestaurantSearch:
            return "/restaurant/search"
        case .fetchRestaurantSummary(let restaurantId, let userId):
            return "/restaurant/\(restaurantId)/\(userId)"
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
        default:
            return .requestPlain
        }
    }
}

