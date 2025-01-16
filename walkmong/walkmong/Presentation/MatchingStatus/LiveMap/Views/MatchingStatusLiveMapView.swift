//
//  MatchingStatusLiveMapView.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit
import NMapsMap

final class MatchingStatusLiveMapView: UIView {
    
    let mapView: NMFNaverMapView = {
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
        let locationOverlay = mapView.mapView.locationOverlay
        locationOverlay.location = position
    }
    
    func setupMap() {
        mapView.showScaleBar = false
        mapView.showZoomControls = false
        mapView.mapView.zoomLevel = 15
        let locationOverlay = mapView.mapView.locationOverlay
        locationOverlay.icon = NMFOverlayImage(image: .currentLocationIcon)
        locationOverlay.anchor = CGPoint(x: 0.5, y: 0.5)
    }

}
