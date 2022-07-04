//
//  NetworkConstants.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

struct URLConstants {
    
    // MARK: - Base URL
    static let baseURL = "http://13.125.157.62:8000"
    static let mockingURL = "https://83008f6f-c9e8-4bb3-a1f8-db102f7e9b13.mock.pstmn.io"
}

struct NetworkEnvironment {
    
    // MARK: - timeOut
    static let requestTimeOut = TimeInterval(10)
    static let resourceTimeOut = TimeInterval(10)
}
