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
    
    func requestReviewList(restaurantId: String,
                           completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.getReviewList(restaurantId: restaurantId),
                      type: [ReviewListEntity].self,
                      decodingMode: .model,
                      completion: completion)
    }
    
    
    func requestReviewWrite(userId: String, restaurantId: String, score: Double, taste: String, good: [String], content: String, image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        AFManager.upload(multipartFormData: ReviewRouter.requestReviewWrite(userId: userId,
                                                                            restaurantId: restaurantId,
                                                                            score: score,
                                                                            taste: taste,
                                                                            good: good,
                                                                            content: content,
                                                                            image: image).multipart,
                         with: ReviewRouter.requestReviewWrite(userId: userId,
                                                               restaurantId: restaurantId,
                                                               score: score,
                                                               taste: taste,
                                                               good: good,
                                                               content: content,
                                                               image: image)).responseData { response in
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
    
    func requestBlogReviewList(restaurantName: String,
                               completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.getBlogReviewList(restaurantName: restaurantName),
                      type: BlogReviewListEntity.self,
                      decodingMode: .model,
                      completion: completion)
    }
    
    func requestUserReview(userId: String,
                           completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.requestUserReview(userId: userId), type: [MyReviewEntity].self, decodingMode: .model, completion: completion)
    }
    
    func requestReviewEnabled(userId: String, restaurantId: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(ReviewRouter.requestReviewEnabled(userId: userId, restaurantId: restaurantId), type: ReviewCheckEntity.self, decodingMode: .model, completion: completion)
    }
    
    func requestReviewDelete(reviewId: String,
                             completion: @escaping (NetworkResult<Any>) -> Void) {
           requestObject(ReviewRouter.requestReviewDelete(reviewId: reviewId),
                         type: ReviewDeleteEntity.self,
                         decodingMode: .message,
                         completion: completion)
           }
    
    func requestReviewEdit(reviewId: String, score: Double, taste: String, good: [String], content: String, image: [UIImage], nameList: [String], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        AFManager.upload(multipartFormData: ReviewRouter.requestReviewEdit(reviewId: reviewId,
                                                                            score: score,
                                                                            taste: taste,
                                                                            good: good,
                                                                            content: content,
                                                                            image: image,
                                                                            nameList: nameList).multipart,
                         with: ReviewRouter.requestReviewEdit(reviewId: reviewId,
                                                              score: score,
                                                              taste: taste,
                                                              good: good,
                                                              content: content,
                                                              image: image,
                                                              nameList: nameList)).responseData { response in
            switch(response.result) {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                guard let reviewRequestData = response.data else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, reviewRequestData, type: ReviewEditEntity.self, decodingMode: .model)
                completion(networkResult)
                
            case .failure(let err) :
                print("ERR")
            }
        }
    }
}
