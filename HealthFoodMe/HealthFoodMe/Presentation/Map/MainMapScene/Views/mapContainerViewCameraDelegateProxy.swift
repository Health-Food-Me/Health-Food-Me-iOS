//
//  mapContainerViewCameraDelegateProxy.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/16.
//

import NMapsMap
import RxCocoa
import RxSwift

final class NaverMapContainerViewDelegateProxy: DelegateProxy<NaverMapContainerView, NMFMapViewTouchDelegate>, DelegateProxyType, NMFMapViewTouchDelegate {
    static func registerKnownImplementations() {
        self.register { (object) -> NaverMapContainerViewDelegateProxy in
            NaverMapContainerViewDelegateProxy(parentObject: object, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: NaverMapContainerView) -> NMFMapViewTouchDelegate? {
        return object.naverMapView.mapView.touchDelegate
    }
    
    static func setCurrentDelegate(_ delegate: NMFMapViewTouchDelegate?, to object: NaverMapContainerView) {
        object.naverMapView.mapView.touchDelegate = delegate
    }
}

extension Reactive where Base: NaverMapContainerView {
    var delegate: DelegateProxy<NaverMapContainerView, NMFMapViewTouchDelegate> {
        return NaverMapContainerViewDelegateProxy.proxy(for: self.base)
    }
    
    var mapViewClicked: Observable<Void> {
        return delegate.methodInvoked(#selector(NMFMapViewTouchDelegate.mapView(_:didTapMap:point:)))
            .map { _ in return ()}
    }
}
