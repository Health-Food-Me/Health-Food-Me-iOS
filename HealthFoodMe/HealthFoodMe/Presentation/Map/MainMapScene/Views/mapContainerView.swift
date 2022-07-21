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
import MapKit

final class NaverMapContainerView: UIView {
  
  private let disposeBag = DisposeBag()
  private var markers = [NMFMarker]()
  private var previousMarker: NMFMarker?
  private var selectedMarker: NMFMarker?
  private var selectedMarkerType: MapPointDataModel?
  internal var zoomLevelChange = PublishRelay<Int>()
  var naverMapView = NMFNaverMapView()
  var delegate: NMFMapViewTouchDelegate?
  var cameraDelegate: NMFMapViewCameraDelegate?
  var pointList = PublishRelay<[MapPointDataModel]>()
  var totalPointList: [MapPointDataModel] = []
  var categoryPointList = PublishRelay<[MapPointDataModel]>()
  var setSelectPoint = PublishRelay<MapPointDataModel>()
  var disableSelectPoint = PublishRelay<Void>()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    bindRelay()
    setUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    bindRelay()
    setUI()
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
    
    naverMapView.mapView.addCameraDelegate(delegate: self)
  }
  
  func moveCameraPosition(_ point: NMGLatLng) {
    let cameraUpdate = NMFCameraUpdate(scrollTo: point)
    cameraUpdate.animation = .fly
    cameraUpdate.animationDuration = 1
    naverMapView.mapView.moveCamera(cameraUpdate)
  }
  
  func moveCameraPositionWithZoom(_ point: NMGLatLng, _ acuumulationInMeter:Int) {
    let zoomLevel = MapAccumulationCalculator.distanceToZoomLevel(distance: acuumulationInMeter)
    let zoomUpdate = NMFCameraUpdate(scrollTo: point, zoomTo: zoomLevel + 1)
    zoomUpdate.animation = .fly
    zoomUpdate.animationDuration = 1.5
    naverMapView.mapView.moveCamera(zoomUpdate)
  }
  
  private func bindRelay() {
    pointList.subscribe(onNext: { [weak self] pointList in
      guard let self = self else { return }
      let data = self.comparePointList(newPoints: pointList)
      self.setPointMarkers(data)
    }).disposed(by: self.disposeBag)
    
    setSelectPoint.subscribe(onNext: { [weak self] selectedPoint in
      self?.setClickedMarker(selectedPoint)
    }).disposed(by: self.disposeBag)
    
    disableSelectPoint.subscribe(onNext: { [weak self] in
      self?.disableAllMarker()
    }).disposed(by: self.disposeBag)
    
    categoryPointList.subscribe(onNext: { [weak self] pointList in
      guard let self = self else { return }
      let data = self.compareCategoryList(newPoints: pointList)
      self.setPointMarkers(data)
    }).disposed(by: self.disposeBag)
  }
  
  private func comparePointList(newPoints: [MapPointDataModel]) -> [MapPointDataModel] {
    var newDataModel = [MapPointDataModel]()
    newPoints.forEach { newData in
      var alreadySet = false
      totalPointList.forEach { oldData in
        if oldData.longtitude == newData.longtitude,
           oldData.latitude == newData.latitude {
          alreadySet = true
        }
      }
      if !alreadySet {
        newDataModel.append(newData)
        totalPointList.append(newData)
      }
    }
    print(newDataModel)
    return newDataModel
  }
  
  /// compareCategoryList: 전체 리스트와 새로운 리스트를 비교하여 전체에만 있는 것들은 삭제, 새로운 것들은 추가해준다
  private func compareCategoryList(newPoints: [MapPointDataModel]) -> [MapPointDataModel] {
    var dataModelForRemove = [MapPointDataModel]()
    var dataModelForAdd = [MapPointDataModel]()
    var newTotalPointList = totalPointList
    
    // 추가할 데이터를 가려낸다
    newPoints.forEach { newData in
      var alreadySet = false
      
      totalPointList.forEach { oldData in
        if oldData.longtitude == newData.longtitude,
           oldData.latitude == newData.latitude {
          alreadySet = true
        }
      }
      
      // 새로운 데이터의 경우, 추가할 data에 append 해준다
      if !alreadySet {
        newTotalPointList.append(newData)
        dataModelForAdd.append(newData)
      }
    }
    
    // 지워줄 데이터를 가려낸다. 기존 데이터에만 있으면 삭제한다.
    totalPointList.forEach { oldData in
      var alreadySet = false
      
      newPoints.forEach { newData in
        if oldData.longtitude == newData.longtitude,
           oldData.latitude == newData.latitude {
          alreadySet = true
        }
      }
      
      // 기존 데이터에만 존재하는 경우
      if !alreadySet {
        var removeIndex = -1
        var shouldRemove = false
        for (targetIndex, targetOldData) in newTotalPointList.enumerated() {
          if targetOldData.longtitude == oldData.longtitude,
             targetOldData.latitude == oldData.latitude {
            shouldRemove = true
            removeIndex = targetIndex
          }
        }
        if shouldRemove {
          newTotalPointList.remove(at: removeIndex)
        }
        dataModelForRemove.append(oldData)
      }
    }
    removePointsList(points: dataModelForRemove)
    totalPointList = newTotalPointList
    return dataModelForAdd
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
  
  /// removePointsList: 포인트 배열을 받아서 마커를 지워준다
  private func removePointsList(points: [MapPointDataModel]) {
    var newMarkers = [NMFMarker]()
    markers.forEach { oldData in
      var alreadySet = false
      points.forEach { newData in
        if oldData.position.lat == newData.latitude,
           oldData.position.lng == newData.longtitude {
          alreadySet = true
        }
      }
      if alreadySet {
        oldData.mapView = nil
      } else {
        newMarkers.append(oldData)
      }
    }
    markers = newMarkers
  }
}

extension NaverMapContainerView: NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    if reason == -1 {
      self.zoomLevelChange.accept(Int(mapView.zoomLevel))
    }
  }
}

struct MapAccumulationCalculator {
  static func zoomLevelToDistance(level: Int) -> Int {
    switch(level) {
    case 20: return   2
    case 19: return   5
    case 18: return   10
    case 17: return   20
    case 16: return   50
    case 15: return   100
    case 14: return   200
    case 13: return   500
    case 12: return   1000
    case 11: return   2000
    case 10: return   5000
    case 9:  return   10000
    case 8:  return   20000
    case 7:  return   200000
    case 6:  return   500000
    case 5:  return   1000000
    default: return   0
    }
  }
  
  static func distanceToZoomLevel(distance: Int) -> Double {
    switch(distance) {
    case 0  ..< 2             : return 20
    case 2  ..< 5             : return 19
    case 5  ..< 10            : return 18
    case 10 ..< 20            : return 17
    case 20 ..< 50            : return 16
    case 50 ..< 100           : return 15
    case 100 ..< 200          : return 14
    case 200 ..< 500          : return 13
    case 500 ..< 1000         : return 12
    case 1000 ..< 2000        : return 11
    case 2000 ..< 5000        : return 10
    case 5000 ..< 10000       : return 9
    case 10000 ..< 20000      : return 8
    case 20000 ..< 200000     : return 7
    case 200000 ..< 500000    : return 6
    case 500000 ..< 1000000   : return 5
    default                   : return 4
    }
  }
}
