//
//  JsonCoder.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/16.
//

import Foundation

/**

  - Description:
 
          JsonEncoder와 decoder를 편리하게 접근하는 용도입니다.
      'Json.decoder.decode'와 같이 호출 가능합니다.
          
*/

enum Json {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    static let decoder = JSONDecoder()
}
