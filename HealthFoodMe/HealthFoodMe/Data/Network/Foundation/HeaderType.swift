//
//  HeaderType.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import Foundation

enum HeaderType {
    case `default`
    case withToken
    case multiPart
    case multiPartWithToken
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case accesstoken = "accesstoken"
}

enum HeaderContent: String {
    case json = "Application/json"
    case multiPart = "multipart/form-data"
    case tokenSerial = ""
}
