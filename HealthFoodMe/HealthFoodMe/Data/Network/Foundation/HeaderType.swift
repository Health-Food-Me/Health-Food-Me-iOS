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
    case tokenSerial = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDRlODRmMGZmMmY5MDBlYTg4YmVjMyIsImlhdCI6MTY1ODEzNDc3OCwiZXhwIjoxNjU4MTM4Mzc4fQ.mngTawFjSZ37wwv6EqeZE1Y5qU2maE1_2ECgW2yTPYs"
}
