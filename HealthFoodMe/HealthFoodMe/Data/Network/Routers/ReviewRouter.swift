//
//  ReviewRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire
import UIKit

enum ReviewRouter {
    case requestReviewWrite(userId: String, restaurantId: String, score: Double, taste: String, good: [String], content: String, image: [UIImage])
    case getReviewList(restaurantId: String)
    case requestUserReview(userId: String)
    case getBlogReviewList(restaurantName: String)
    case requestReviewEnabled(userId: String, restaurantId: String)
    case requestReviewDelete(reviewId: String)
    case requestReviewEdit(reviewId: String, score: Double, taste: String, good: [String], content: String, image: [UIImage], nameList: [String])
}

extension ReviewRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .requestReviewWrite:
            return .post
        case .requestReviewDelete:
            return .delete
        case .requestReviewEdit:
            return .put
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getReviewList(let restaurantId):
            return "review/restaurant/\(restaurantId)/"
        case .requestUserReview(let userId):
            return "/review/user/\(userId)"
        case .requestReviewWrite(let userId,let restaurantId,_,_,_,_,_):
            return "/review/\(userId)/\(restaurantId)"
        case .getBlogReviewList(let restaurantName):
            return "review/restaurant/\(restaurantName)/blog"
        case .requestReviewEnabled(let userId, let restaurantId):
            return "/user/check/\(userId)/\(restaurantId)"
        case .requestReviewDelete(let reviewId):
            return "/review/\(reviewId)"
        case .requestReviewEdit(let reviewId,_,_,_,_,_,_):
            return "/review/\(reviewId)"
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
        case .getBlogReviewList(let restaurantName):
            let requestParams: [String: Any] = [
                "restaurantName": restaurantName
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
    
    var multipart: MultipartFormData {
        switch self {
        case .requestReviewWrite(_,_,let score, let taste, let good, let content, let image):
            let multiPart = MultipartFormData()
            
            multiPart.append(Data(String(score).utf8), withName: "score")
            multiPart.append(Data(taste.utf8), withName: "taste")
            good.forEach {
                let data = Data(String($0).utf8)
                multiPart.append(data, withName: "good")
            }
            multiPart.append(Data(content.utf8), withName: "content")
            for (index, item) in image.enumerated() {
                if let imageData = item.pngData() {
                    multiPart.append(imageData, withName: "image", fileName: "image\(index).png", mimeType: "image/png")
                }
            }
            return multiPart
        case .requestReviewEdit(_,let score, let taste, let good, let content, let image, let nameList):
            let multiPart = MultipartFormData()
            
            multiPart.append(Data(String(score).utf8), withName: "score")
            multiPart.append(Data(taste.utf8), withName: "taste")
            good.forEach {
                let data = Data(String($0).utf8)
                multiPart.append(data, withName: "good")
            }
            multiPart.append(Data(content.utf8), withName: "content")
            for (index, item) in image.enumerated() {
                print(index, item)
                if let imageData = item.pngData() {
                    multiPart.append(imageData, withName: "image", fileName: "image\(index).png", mimeType: "image/png")
                }
            }
            nameList.forEach {
                let data = Data(String($0).utf8)
                multiPart.append(data, withName: "nameList")
            }
            return multiPart
        default: return MultipartFormData()
        }
    }
    
    var header: HeaderType {
        switch self {
        case .requestReviewWrite:
            return .multiPartWithToken
        default:
            return .withToken
        }
        
        var header: HeaderType {
            switch self {
            case .requestReviewWrite, .requestReviewEdit:
                return .multiPartWithToken
            default:
                return .withToken
            }
        }
    }
}

