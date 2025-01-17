//
//  MatchingStatusLiveMapView.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit
import NMapsMap

final class MatchingStatusLiveMapView: UIView {
    
    private var marker: NMFMarker?
    
    private let mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        return mapView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setupMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubview(mapView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateLocation(position: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: position.lat, lng: position.lng))
        cameraUpdate.animation = .easeIn
        mapView.mapView.moveCamera(cameraUpdate)
        marker?.mapView = nil
        marker = NMFMarker(position: position)
        marker?.iconImage = NMFOverlayImage(image: .walkmongCurrentLocationIcon)
        marker?.width = 40
        marker?.height = 40
        marker?.mapView = mapView.mapView
    }
    
    func setupMap() {
        mapView.showScaleBar = false
        mapView.showZoomControls = false
        mapView.mapView.zoomLevel = 15
    }

}
