//
//  BaseService.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation
import Alamofire

class BaseService {

    @frozen enum DecodingMode {
        case model
        case message
        case general
    }
    
    let AFManager: Session = {
        var session = AF
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = NetworkEnvironment.requestTimeOut
        configuration.timeoutIntervalForResource = NetworkEnvironment.resourceTimeOut
        let eventLogger = APIEventLogger()
        session = Session(configuration: configuration, eventMonitors: [eventLogger])
        return session
    }()
    
    func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, type: T.Type, decodingMode: DecodingMode = .general) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GeneralResponse<T>.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200..<300:
            
            switch decodingMode {
            case .model:
                return .success(decodedData.data ?? "None-Data")
                
            case .message:
                return .success(decodedData.message ?? "None-Data")
                
            case .general:
                return .success(decodedData)
            }
            
        case 400..<500:
            return .requestErr(decodedData.status)
            
        case 500:
            return .serverErr
            
        default:
            return .networkFail
        }
    }
}
