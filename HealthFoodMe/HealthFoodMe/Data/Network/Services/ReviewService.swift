//
//  ReviewService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

class ReviewService: BaseService {
    static let shared = ReviewService()
    
    private override init() {}
}

extension ReviewService {
    
    func requestReviewWrite(userId: String, restaurantId: String, score: Double, taste: String, good: [String], content: String, image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        AFManager.upload(multipartFormData: ReviewRouter.requestReviewWrite(userId: userId,
                                                                            restaurantId: restaurantId,
                                                                            score: score,
                                                                            taste: taste,
                                                                            good: good,
                                                                            content: content,
                                                                            image: image).multipart,
                         with: ReviewRouter.requestReviewWrite(userId: userId,
                                                               restaurantId: restaurantId, score: score, taste: taste, good: good, content: content, image: image)).responseData { response in
            switch(response.result) {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                guard let reviewRequestData = response.data else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, reviewRequestData, type: ReviewWriteEntity.self, decodingMode: .model)
                completion(networkResult)
                
                
            case .failure(let err) :
                print("ERR")
            }
        }
    }
}
