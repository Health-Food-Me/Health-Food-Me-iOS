//
//  MapLiterals.Location.swift
//  HealthFoodMe
//
//  Created by 송지훈 on 2022/07/15.
//

import NMapsMap

struct MapLiterals {
    
}

extension MapLiterals {
    struct Location {
        static let gangnamStation: NMGLatLng = NMGLatLng(lat: 37.497952, lng: 127.027619)
    }
    
    struct ZoomScale {
        static let Maximum = 1000.0 * 1000.0 * 10
        static let KM1 = 1000.0
        static let KM1_5 = 1500.0
        static let KM2 = 2000.0
    }
}
