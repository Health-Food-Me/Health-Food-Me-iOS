//
//  UserService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Alamofire

class UserService: BaseService {
    static let shared = UserService()
    
    private override init() {}
}

extension UserService {
    func getScrapList(userId: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestObject(UserRouter.getScrapList(userId: userId), type: [ScrapListEntity].self, decodingMode: .model, completion: completion)
    }
}
