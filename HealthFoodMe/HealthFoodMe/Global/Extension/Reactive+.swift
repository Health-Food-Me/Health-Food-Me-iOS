//
//  Reactive+.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

extension ObservableType {
    internal func doOnNext(_ onNext: @escaping (Element) throws -> Void) -> Observable<Element> {
        return `do`(onNext: onNext)
    }
    
    internal func doOnError(_ onError: @escaping (Error) throws -> Void) -> Observable<Element> {
        return `do`(onError: onError)
    }
}

extension ObservableType {
    public func observeOnMain() -> Observable<Element> {
        observe(on: MainScheduler.instance)
    }
    public func observeOnBackground() -> Observable<Element> {
        observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func throttleOnMain(_ dueTime: RxTimeInterval, latest: Bool = true) -> Observable<Element> {
        throttle(dueTime, latest: latest, scheduler: MainScheduler.instance)
    }
    
    public func throttleOnBackground(_ dueTime: RxTimeInterval, latest: Bool = true) -> Observable<Element> {
        throttle(dueTime, latest: latest, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

