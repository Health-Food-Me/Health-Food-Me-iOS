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
}

extension ReviewRouter: BaseRouter {
    var method: HTTPMethod {
        switch self {
        case .requestReviewWrite:
            return .post
        }
    }
    
    var header: HeaderType {
        return .multiPartWithToken
    }
    
    var path: String {
        switch self {
        case .requestReviewWrite(let userId, let restaurantId,_,_,_,_,_):
            return "/review/user/\(userId)/restaurant/\(restaurantId)"
        }
    }
    
    var parameters: RequestParams {
        return .requestPlain
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
                print(index, item)
                if let imageData = item.pngData() {
                    multiPart.append(imageData, withName: "image", fileName: "image\(index).png", mimeType: "image/png")
                }
            }
            
            return multiPart
        }
    }
}
