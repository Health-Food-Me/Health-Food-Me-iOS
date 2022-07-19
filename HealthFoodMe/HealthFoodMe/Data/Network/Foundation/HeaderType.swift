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
    case reissuance
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case accesstoken = "token"
    case refreshtoken = "refreshtoken"
    case accesstokenForReissuance = "accesstoken"
}

enum HeaderContent: String {
    case json = "application/json"
    case multiPart = "multipart/form-data"
    case tokenSerial = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDRlZDI0MGZmMmY5MDBlYTg4YmVmNiIsImlhdCI6MTY1ODE2OTIwNywiZXhwIjoxNjU4MTcyODA3fQ.db5U6ro0LAVpquSHR2ICVpe4syK98VXAhwoc6vLsDOk"
}
