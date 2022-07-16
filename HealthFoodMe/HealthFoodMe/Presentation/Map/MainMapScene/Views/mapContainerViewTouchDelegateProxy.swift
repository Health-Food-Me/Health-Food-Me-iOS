////
////  NaverMapContainerViewDelegateProxy.swift
////  NaverMap + RxDelegate
////
////  Created by 송지훈 on 2022/07/12.
////
//
//import NMapsMap
//import RxCocoa
//import RxSwift
//
//final class NaverMapContainerCameraDelegateProxy: DelegateProxy<NaverMapContainerView, NMFMapViewTouchDelegate>, DelegateProxyType, NMFMapViewTouchDelegate {
//    static func registerKnownImplementations() {
//        self.register { (object) -> NaverMapContainerCameraDelegateProxy in
//          NaverMapContainerCameraDelegateProxy(parentObject: object, delegateProxy: self)
//        }
//    }
//    
//    static func currentDelegate(for object: NaverMapContainerView) -> NMFMapViewTouchDelegate? {
//      return object.naverMapView.mapView.addCameraDelegate(delegate: object)
//    }
//    
//    static func setCurrentDelegate(_ delegate: NMFMapViewTouchDelegate?, to object: NaverMapContainerView) {
//        object.naverMapView.mapView.touchDelegate = delegate
//    }
//}
//
//extension Reactive where Base: NaverMapContainerView {
//    var delegate: DelegateProxy<NaverMapContainerView, NMFMapViewTouchDelegate> {
//        return NaverMapContainerViewDelegateProxy.proxy(for: self.base)
//    }
//    
//    var mapViewClicked: Observable<Void> {
//        return delegate.methodInvoked(#selector(NMFMapViewTouchDelegate.mapView(_:didTapMap:point:)))
//            .map { _ in return ()}
//    }
//}
