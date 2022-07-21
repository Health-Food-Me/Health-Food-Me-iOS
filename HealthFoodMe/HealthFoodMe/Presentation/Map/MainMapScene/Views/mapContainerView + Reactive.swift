//
//  NaverMapContainerView + Reactive.swift
//  NaverMap + RxDelegate
//
//  Created by 송지훈 on 2022/07/12.
//

import NMapsMap
import RxCocoa
import RxSwift

extension Reactive where Base: NaverMapContainerView {
    internal var pointList: Binder<[MapPointDataModel]> {
        return Binder(self.base) { containerView, points in
            containerView.pointList.accept(points)
        }
    }
    
    internal var categoryPointList: Binder<[MapPointDataModel]> {
        return Binder(self.base) { containerView, category in
            containerView.categoryPointList.accept(category)
        }
    }
}

extension Reactive where Base: NaverMapContainerView {
    internal var currentSelectPoint: Binder<MapPointDataModel> {
        return Binder(self.base) { containerView, point in
            containerView.setSelectPoint.accept(point)
        }
    }
}
