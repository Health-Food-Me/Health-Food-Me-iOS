//
//  ReviewRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum ReviewRouter {
    case getReviewList(restaurantId: String)
    case getBlogReviewList(restaurantName: String)
}

extension ReviewRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        default :
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getReviewList(let restaurantId):
            return "review/restaurant/\(restaurantId)/"
        case .getBlogReviewList(let restaurantName):
            return "review/restaurant/\(restaurantName)/blog"
        default:
            return ""
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getReviewList(let restaurantId):
            let requestParams: [String: Any] = [
                "restaurantId": restaurantId
            ]
            return .query(requestParams)
        case .getBlogReviewList(let restaurantName):
            let requestParams: [String: Any] = [
                "restaurantName": restaurantName
            ]
            return .query(requestParams)
        default:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self {
        default:
            return .withToken
        }
    }
}
