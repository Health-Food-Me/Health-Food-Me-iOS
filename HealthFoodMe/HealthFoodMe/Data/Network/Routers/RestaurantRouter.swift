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
    case fetchRestaurantList(longitude: Double, latitude: Double, zomm: Double, category: String)
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
        case .fetchRestaurantList:
            return "/restaurant"
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
                "longtitude": searchRequest.longtitude,
                "latitude": searchRequest.latitude,
                "zoom": searchRequest.zoom,
                "keyword": searchRequest.keyword
            ]
            return .query(requestQuery)
        case .fetchRestaurantList(let lng, let lat, let zoom, let category):
            let requestQuery: [String: Any] = [
                "longtitude": lng,
                "latitude": lat,
                "zoom": zoom,
                "category": category
            ]
            return .query(requestQuery)
        case .fetchRestaurantSummary(let restaurantId, let userId):
            let requestQuery: [String: Any] = [
                "restaurantId": restaurantId,
                "userId": userId
            ]
            return .query(requestQuery)
        default:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self{
        default:
            return .withToken
        }
    }
}
