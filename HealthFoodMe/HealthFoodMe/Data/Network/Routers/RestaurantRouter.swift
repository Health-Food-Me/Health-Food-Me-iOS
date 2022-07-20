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
    case fetchRestaurantDetail(restaurantId: String, userId: String, latitude: Double, longitude: Double)
}

extension RestaurantRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
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
        case .fetchRestaurantDetail(let restaurantId, let userId, _, _):
            return "/restaurant/\(restaurantId)/\(userId)/menus"
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
                "longitude": searchRequest.longtitude,
                "latitude": searchRequest.latitude,
                "zoom": searchRequest.zoom,
                "keyword": searchRequest.keyword
            ]
            return .query(requestQuery)
        case .fetchRestaurantList(let lng, let lat, let zoom, let category):
            let requestQuery: [String: Any] = [
                "longitude": lng,
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
        case .fetchRestaurantDetail(_, _, let latitude, let longitude):
            let requestQuery: [String: Any] = [
                "latitude": latitude,
                "longitude": longitude
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
