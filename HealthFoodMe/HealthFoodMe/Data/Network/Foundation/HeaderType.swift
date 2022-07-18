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
    case tokenSerial = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDFjMDgxYzRiZWFmMWUzOTdiNWQ0MCIsImlhdCI6MTY1ODAxMjU4MSwiZXhwIjoxNjU4MDE2MTgxfQ.L-I5JldjffkdNLWVvZb7XYRvRDD2yy98lZvQPoShV_0"
}
