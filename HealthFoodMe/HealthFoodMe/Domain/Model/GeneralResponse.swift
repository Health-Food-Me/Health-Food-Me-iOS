//
//  GeneralResponse.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

struct GeneralResponse<T> {
    let success: Bool
    let status: Int
    let message: String?
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case success
        case status
        case message
        case data
    }
}

extension GeneralResponse: Decodable where T: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        status = try container.decode(Int.self, forKey: .status)
        message = try? container.decode(String.self, forKey: .message)
        data = try? container.decode(T.self, forKey: .data)
    }
}
