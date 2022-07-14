//
//  EncodeURLKorean.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/14.
//

import Foundation
/// - Description: URL에 한국어가 있는 경우, 퍼센트 문자로 치환합니다

extension URL {
  
  static func decodeURL(urlString: String) -> URL? {
    if let url = URL(string: urlString)  {
      return url
    } else {
      let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
      return URL(string: encodedString)
    }
  }
}

