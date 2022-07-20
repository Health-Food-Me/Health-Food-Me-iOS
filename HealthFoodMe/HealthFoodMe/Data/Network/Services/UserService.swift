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
    func getScrapList(userId: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(UserRouter.getScrapList(userId: userId), type: [ScrapListEntity].self, decodingMode: .model, completion: completion)
    }
    
    func putScrap(userId: String, restaurantId: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(UserRouter.putScrap(userId: userId, restaurantId: restaurantId), type: ScrapEntity.self, decodingMode: .message, completion: completion)
    }
    
    func putUserNickname(userId: String,nickname: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        requestObject(UserRouter.putUserNickname(userId: userId,
                                                 nickname: nickname),
                      type: NicknameEntity.self, decodingMode: .model, completion: completion)
    }
    
    func deleteUserNickname(userId: String, completion: @escaping(NetworkResult<Any>) -> Void){
        requestObjectWithEmptyResponse(UserRouter.deleteUser(userId: userId), completion: completion)
    }
    
    func getUserNickname(userId: String,  completion: @escaping(NetworkResult<Any>) -> Void){
        requestObject(UserRouter.getUserName(userId: userId),
                      type: UserEntity.self, decodingMode: .model, completion: completion)
    }
}
