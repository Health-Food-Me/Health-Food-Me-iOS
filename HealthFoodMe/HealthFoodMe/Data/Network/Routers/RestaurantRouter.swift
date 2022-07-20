//
//  RestaurantRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum RestaurantRouter {
    case requestRestaurantSearch(query: String)
    case requestRestaurantSearchResult(searchRequest: SearchRequestEntity)
    case fetchRestaurantSummary(restaurantId: String, userId: String)
    case getMenuPrescription(restaurantId: String)
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
            return "/restaurant/search/auto"
        case .requestRestaurantSearchResult:
            return "/restaurant/search/card"
        case .getMenuPrescription(let restaurantId):
            return "/restaurant/\(restaurantId)/prescription"
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
        case .requestRestaurantSearchResult(let searchRequest):
            let requestQuery: [String: Any] = [
                "longitude": searchRequest.longitude,
                "latitude": searchRequest.latitude,
                "keyword": searchRequest.keyword
            ]
            return .query(requestQuery)
        default:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self{
        case .requestRestaurantSearch:
            return .withToken
        default:
            return .withToken
        }
    }
}
