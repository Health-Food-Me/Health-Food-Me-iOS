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

final class NaverMapContainerView: UIView{
  
  private let disposeBag = DisposeBag()
  private var markers = [NMFMarker]()
  private var previousMarker: NMFMarker? = nil
  private var selectedMarker: NMFMarker? = nil
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
    naverMapView.showLocationButton = true
    naverMapView.mapView.positionMode = .compass
    
    addSubview(naverMapView)
    
    naverMapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
  }

  private func moveCameraPosition(_ point: NMGLatLng) {
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
        self.setMarkState(mark: marker, selectState: false)
        marker.touchHandler = { _ in
          if let seletedMark = self.selectedMarker {
            self.setMarkState(mark: seletedMark, selectState: false)
          }
          self.setMarkState(mark: marker, selectState: true)
          self.setSelectPoint.accept(point)
          self.selectedMarker = marker
          return true
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
    if let seletedMark = self.selectedMarker {
      setMarkState(mark: seletedMark, selectState: false)
    }
    setMarkState(mark: marker, selectState: true)
    self.selectedMarker = marker
  }
  
  private func disableAllMarker() {
    guard selectedMarker != nil else { return }
    setMarkState(mark: selectedMarker!, selectState: false)
  }
  
  private func setMarkState(mark: NMFMarker, selectState: Bool) {
    let iconName = selectState ? "icn_normal_seleted" : "icn_normal"
    mark.iconImage = NMFOverlayImage.init(image: UIImage(named: iconName) ?? UIImage())
  }
}


