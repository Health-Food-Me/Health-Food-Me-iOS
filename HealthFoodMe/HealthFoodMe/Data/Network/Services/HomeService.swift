//
//  HomeService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

import Alamofire

class HomeService: BaseService {
    static let shared = HomeService()
    
    private override init() {}
}

extension HomeService {
    
    func getPostDetail(postId: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(HomeRouter.getPostDetail(postId: postId)).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return}
                let networkResult = self.judgeStatus(by: statusCode, data, type: PostDetail.self, decodingMode: .model)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getPostList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(HomeRouter.getPostList).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return}
//                let networkResult = self.judgeStatus(by: statusCode, data, type: [PostListDataModel].self, decodingMode: .model)
//                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func changeSellStatus(postId: String, onSale: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(HomeRouter.changeSellStatus(postId: postId, onSale: onSale)).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return}
                let networkResult = self.judgeStatus(by: statusCode, data, type: NoData.self, decodingMode: .message)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func changeLikeStatus(postId: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(HomeRouter.changeLikeStatus(postId: postId)).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return}
                let networkResult = self.judgeStatus(by: statusCode, data, type: NoData.self, decodingMode: .message)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
//    func createPostWrite(imageCount: Int, title: String, category: String, price: Int, contents: String, isPriceSuggestion: Bool, completion: @escaping (NetworkResult<Any>) -> (Void)) {
//        AFManager.request(HomeRouter.createPostWrite(imageCount: imageCount, title: title, category: category, price: price, contents: contents, isPriceSuggestion: isPriceSuggestion)).responseData { response in
//            switch response.result {
//            case .success:
//                guard let statusCode = response.response?.statusCode else { return }
//                guard let data = response.data else { return }
//                let networkResult = self.judgeStatus(by: statusCode, data, type: PostWrite.self, decodingMode: .model)
//                completion(networkResult)
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
    

}

