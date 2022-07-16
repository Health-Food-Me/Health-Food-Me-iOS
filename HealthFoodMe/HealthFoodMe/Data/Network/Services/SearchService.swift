//
//  SearchService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/16.
//

import Foundation

import Alamofire

class SearchService: BaseService {
    static let shared = SearchService()
    
    private override init() {}
}

struct SearchModel: Codable {
    
}

extension SearchService {
    
    func requestRestaurantSearch(query: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        requestObject(SearchRouter.requestRestaurantSearch(query: query), type: SearchModel.self, decodingMode: .general, completion: completion)
    }
}
