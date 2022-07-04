//
//  HomeRouter.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation
import Alamofire

enum HomeRouter {
    case getPostDetail(postId: String)
    case changeSellStatus(postId: String, onSale: String)
    case changeLikeStatus(postId: String)
    case createPostWrite(imageCount: Int, title: String, category: String, price: Int, contents: String, isPriceSuggestion: Bool)
    case getPostList
}

extension HomeRouter: BaseRouter {
    
    var path: String {
        switch self {
        case .getPostDetail(let postId):
            return "/feed/\(postId)"
        case .changeSellStatus(_, _):
            return "/feed/on-sale"
        case .changeLikeStatus(let postId):
            return "/feed/like/\(postId)"
        case .createPostWrite(_, _, _, _, _, _):
            return "/feed"
        case .getPostList:
            return "/feed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPostDetail(_):
            return .get
        case .changeSellStatus(_, _):
            return .put
        case .changeLikeStatus(_):
            return .put
        case .createPostWrite(_, _, _, _, _, _):
            return .post
        case .getPostList:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getPostDetail(_):
            return .requestPlain
        case .changeSellStatus(let postId, let onSale):
            let body: [String : Any] =
            ["id": postId,
             "onSale": onSale ]
            return .requestBody(body)
        case .changeLikeStatus(_):
            return .requestPlain
        case .createPostWrite(let imageCount, let title, let category, let price, let contents, let isPriceSuggestion):
            let body: [String : Any] =
            ["imageCount" : imageCount,
             "title" : title,
             "category" : category,
             "price" : price,
             "contents" : contents,
             "isPriceSuggestion" : isPriceSuggestion]
            return .requestBody(body)
            
        case .getPostList:
            return .requestPlain
        }
    }
}

