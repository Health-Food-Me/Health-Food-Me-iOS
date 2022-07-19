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
    case tokenSerial = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyZDUxOGUwMjljNGNmODkxODQ1OGJlOCIsImVtYWlsIjoiZGJzdGoxNkBuYXZlci5jb20iLCJpYXQiOjE2NTgyNTU2NDUsImV4cCI6MTY1ODI1OTI0NX0.t1Jyzjnlzf-L432Gs6AqHlNmHakwyh41Wmy_PhrMkr8"
}
