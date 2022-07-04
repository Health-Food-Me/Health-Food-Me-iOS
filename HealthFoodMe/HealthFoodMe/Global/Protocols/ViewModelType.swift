//
//  ViewModelType.swift
//  DaangnMarket-iOS
//
//  Created by Junho Lee on 2022/05/16.
//

import Foundation
import RxSwift

protocol ViewModelType{
  associatedtype Input
  associatedtype Output
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output
}
