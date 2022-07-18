//
//  SearchService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Foundation

import Alamofire

class RestaurantService: BaseService {
    static let shared = RestaurantService()
    
    private override init() {}
}

extension RestaurantService {
    
    func requestRestaurantSearch(query: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestObject(RestaurantRouter.requestRestaurantSearch(query: query), type: SearchDataModel.self, decodingMode: .general, completion: completion)
    }
    
    func fetchRestaurantSummary(completion: @escaping (NetworkResult<Any>) -> Void) {
        requestObject(RestaurantRouter.fetchRestaurantSummary(restaurantId: "", userId: ""), type: RestaurantSummary.self, decodingMode: .model, completion: completion)
    }
    
    func getMenuPrescription(restaurantId: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestObject(RestaurantRouter.getMenuPrescription(restaurantId: restaurantId), type: CopingTabEntity.self, decodingMode: .model, completion: completion)
    }
}
