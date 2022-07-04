//
//  Router.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
    var header: HeaderType { get }
    var multipart: MultipartFormData { get }
}

// MARK: asURLRequest()

extension BaseRouter {
    
    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        urlRequest = self.makeHeaderForRequest(to: urlRequest)
        
        return try self.makeParameterForRequest(to: urlRequest, with: url)
    }
    
    private func makeHeaderForRequest(to request: URLRequest) -> URLRequest {
        var request = request
        
        switch header {
            
        case .default:
            request.setValue(HeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
        case .withToken:
            request.setValue(HeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(HeaderContent.tokenSerial.rawValue, forHTTPHeaderField: HTTPHeaderField.accesstoken.rawValue)
            
        case .multiPart:
            request.setValue(HeaderContent.multiPart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
        case .multiPartWithToken:
            request.setValue(HeaderContent.multiPart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(HeaderContent.tokenSerial.rawValue, forHTTPHeaderField: HTTPHeaderField.accesstoken.rawValue)
        }
        
        return request
    }
    
    private func makeParameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        
        switch parameters {
            
        case .query(let query):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case .requestBody(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .queryBody(let query, let body):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .requestPlain:
            break
            
        }
        
        return request
    }
}

// MARK: baseURL & header

extension BaseRouter {
    var baseURL: String {
        return URLConstants.baseURL
    }
    
    var header: HeaderType {
        return HeaderType.default
    }
    
    var multipart: MultipartFormData {
        return MultipartFormData()
    }
}

// MARK: ParameterType

enum RequestParams {
    case queryBody(_ query: [String : Any], _ body: [String : Any])
    case query(_ query: [String : Any])
    case requestBody(_ body: [String : Any])
    case requestPlain
}
