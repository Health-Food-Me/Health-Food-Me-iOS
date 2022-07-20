//
//  ReviewRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

enum ReviewRouter {
    case getReviewList(restaurantId: String)
    case requestUserReview(userId: String)
    case requestReviewEnabled(userId: String, restaurantId: String)
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
        case .requestUserReview(let userId):
            return "/review/user/\(userId)"
        case .requestReviewEnabled(let userId, let restaurantId):
            return "/review/check/\(userId)/\(restaurantId)"
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
        case .requestUserReview(let userId):
            let requestParams: [String: Any] = [
                "userId": userId
            ]
            return .query(requestParams)
        case .requestReviewEnabled(let userId, let restaurantId):
            let requestParams: [String: Any] = [
                "userId": userId,
                "restaurantId": restaurantId
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
