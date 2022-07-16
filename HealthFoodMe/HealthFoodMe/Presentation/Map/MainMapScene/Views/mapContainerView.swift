//
//  NaverMapContainerView.swift
//  NaverMap + RxDelegate
//
//  Created by 송지훈 on 2022/07/12.
//

import Foundation
import NMapsMap
import RxRelay
import RxSwift

final class NaverMapContainerView: UIView {
    
    private let disposeBag = DisposeBag()
    private var markers = [NMFMarker]()
    private var previousMarker: NMFMarker?
    private var selectedMarker: NMFMarker?
    private var selectedMarkerType: MapPointDataModel?
    var naverMapView = NMFNaverMapView()
    var delegate: NMFMapViewTouchDelegate?
    var pointList = PublishRelay<[MapPointDataModel]>()
    var setSelectPoint = PublishRelay<MapPointDataModel>()
    var disableSelectPoint = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindRelay()
        setUI()
        moveCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bindRelay()
        setUI()
        moveCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881))
    }
}

extension NaverMapContainerView {
    private func setUI() {
        naverMapView = NMFNaverMapView(frame: self.frame)
        naverMapView.mapView.positionMode = .direction
        naverMapView.mapView.locationOverlay.hidden = true
        naverMapView.showZoomControls = false
        
        addSubview(naverMapView)
        
        naverMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func moveCameraPosition(_ point: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: point)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 2
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    private func bindRelay() {
        pointList.subscribe(onNext: { [weak self] pointList in
            guard let self = self else { return }
            self.setPointMarkers(pointList)
        }).disposed(by: self.disposeBag)
        
        setSelectPoint.subscribe(onNext: { [weak self] selectedPoint in
            self?.setClickedMarker(selectedPoint)
        }).disposed(by: self.disposeBag)
        
        disableSelectPoint.subscribe(onNext: { [weak self] in
            self?.disableAllMarker()
        }).disposed(by: self.disposeBag)
        
    }
    
    private func setPointMarkers(_ points: [MapPointDataModel]) {
        DispatchQueue.global(qos: .default).async {
            for point in points {
                let marker = NMFMarker()
                marker.position = NMGLatLng.init(lat: point.latitude, lng: point.longtitude)
                switch point.type {
                case .normalFood:
                    self.setNormalMarkState(mark: marker, selectState: false)
                    marker.touchHandler = { _ in
                        if let seletedMark = self.selectedMarker {
                            self.setNormalMarkState(mark: seletedMark, selectState: false)
                        }
                        self.setNormalMarkState(mark: marker, selectState: true)
                        self.setSelectPoint.accept(point)
                        self.selectedMarker = marker
                        self.selectedMarkerType = point
                        return true
                    }
                case .healthFood:
                    self.setHealthMarkState(mark: marker, selectState: false)
                    marker.touchHandler = { _ in
                        if let seletedMark = self.selectedMarker {
                            self.setHealthMarkState(mark: seletedMark, selectState: false)
                        }
                        self.setHealthMarkState(mark: marker, selectState: true)
                        self.setSelectPoint.accept(point)
                        self.selectedMarker = marker
                        self.selectedMarkerType = point
                        return true
                    }
                }
                self.markers.append(marker)
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                for marker in self.markers {
                    marker.mapView = self.naverMapView.mapView
                }
            }
        }
    }
    
    private func setClickedMarker(_ selectedPoint: MapPointDataModel) {
        let NMGPosition = NMGLatLng(lat: selectedPoint.latitude,
                                    lng: selectedPoint.longtitude)
        guard let marker = markers.filter({ point in
            return point.position == NMGPosition
        }).first else { return }
        moveCameraPosition(NMGPosition)
        if let seletedMark = self.selectedMarker,
           let type = selectedMarkerType?.type {
            switch type {
            case .healthFood:
                setHealthMarkState(mark: seletedMark, selectState: false)
            case .normalFood:
                setNormalMarkState(mark: seletedMark, selectState: false)
            }
        }
        switch selectedPoint.type {
        case .healthFood:
            setHealthMarkState(mark: marker, selectState: true)
        case .normalFood:
            setNormalMarkState(mark: marker, selectState: true)
        }
        self.selectedMarker = marker
        self.selectedMarkerType = selectedPoint
    }
    
    private func disableAllMarker() {
        guard selectedMarker != nil, let markerType = selectedMarkerType?.type else { return }
        switch markerType {
        case .healthFood:
            setHealthMarkState(mark: selectedMarker!, selectState: false)
        case .normalFood:
            setNormalMarkState(mark: selectedMarker!, selectState: false)
        }
    }
    
    private func setNormalMarkState(mark: NMFMarker, selectState: Bool) {
        let iconName = selectState ? "icn_normal_seleted" : "icn_normal"
        mark.iconImage = NMFOverlayImage.init(image: UIImage(named: iconName) ?? UIImage())
    }
    
    private func setHealthMarkState(mark: NMFMarker, selectState: Bool) {
        let iconName = selectState ? "icn_diet_selected" : "icn_diet"
        mark.iconImage = NMFOverlayImage.init(image: UIImage(named: iconName) ?? UIImage())
    }
}
