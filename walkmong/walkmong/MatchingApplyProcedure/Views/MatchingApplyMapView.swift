//
//  MatchingApplyMapView.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit
import NMapsMap

protocol MatchingApplyMapViewDelegate: AnyObject {
    func matchingApplyMapView(_ view: MatchingApplyMapView, didSelectLocationAt target: NMGLatLng)
    func willSelectLocation()
    func didTapNextButton()
}

class MatchingApplyMapView: UIView {
    weak var delegate: MatchingApplyMapViewDelegate?
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    let mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        return mapView
    }()
    
    private let centerMarker: CustomMarker = {
        let marker = CustomMarker()
        marker.height = 64
        marker.width = 50
        return marker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
        setupMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        addSubviews(mapView, nextButton)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    private func setupMap() {
        let initialPosition = NMGLatLng(lat: 37.479132, lng: 127.011770)
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialPosition)
        mapView.mapView.moveCamera(cameraUpdate)
        mapView.showScaleBar = false
        mapView.showZoomControls = false
        
        centerMarker.position = initialPosition
        centerMarker.mapView = mapView.mapView
        centerMarker.touchHandler = { (overlay) -> Bool in
            self.centerMarker.showInfoWindow()
            return true // Indicates that the event was handled
        }
        
        mapView.mapView.addCameraDelegate(delegate: self)
    }
    
    func updateButtonState(value: Bool){
        self.nextButton.backgroundColor = value ? .gray600 : .gray300
    }
    
    @objc private func didTapNextButton(){
        delegate?.didTapNextButton()
    }
    
}

extension MatchingApplyMapView: NMFMapViewCameraDelegate {
    // 화면 이동을 추적
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        centerMarker.position = mapView.cameraPosition.target
        self.nextButton.backgroundColor = .gray300
        delegate?.willSelectLocation()
    }
    // 화면 이동을 추적
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        centerMarker.position = mapView.cameraPosition.target
        self.nextButton.backgroundColor = .gray300
        delegate?.willSelectLocation()
    }
    // 이동이 끝났을 때 좌표값 print
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(mapView.cameraPosition.target)
        delegate?.matchingApplyMapView(self, didSelectLocationAt: mapView.cameraPosition.target)
        self.nextButton.backgroundColor = .gray600
    }
}
