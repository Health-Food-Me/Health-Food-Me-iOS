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
    case accesstoken = "token"
}

enum HeaderContent: String {
    case json = "application/json"
    case multiPart = "multipart/form-data"
    case tokenSerial = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDJmOWFjZDUxNWJiZDhkZmM0ZTI4YSIsImlhdCI6MTY1Nzk5NzgyOCwiZXhwIjoxNjU4MDAxNDI4fQ.Hkf-yLA_aUhCHa_m7yayE8fP7rlW6eT3lDXA-vreYIo"
}
