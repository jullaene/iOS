//
//  SignupMapView.swift
//  walkmong
//
//  Created by 황채웅 on 1/6/25.
//

import UIKit
import NMapsMap

protocol SignupMapViewDelegate: AnyObject {
    func didTapNextButton(dongAddress: String, latitude: Double, longitude: Double)
}

final class SignupMapView: UIView {

    var initialPosition: NMGLatLng?
    weak var delegate: SignupMapViewDelegate?
    
    private let mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        return mapView
    }()
    private let mapBlockerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let centerMarker: CustomMarker = {
        let marker = CustomMarker()
        marker.height = 64
        marker.width = 50
        return marker
    }()
    private var selectedDistanceIndex: Int = 0
    private let nextButton = NextButton(text: "현재 위치로 등록")
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    private let placeUpperLabel = MainHighlightParagraphLabel(text: "내동네")
    private let markerPinIconImageView: UIImageView = {
        let imageView = UIImageView(image: .mainBlueMarkerPin)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let dongAddressLabel = LargeTitleLabel(text: "동 주소", textColor: .mainBlue)
    private var distanceDots: [UIView] = []
    private var distanceLabels: [UILabel] = []
    private let distanceFilterKey = "DistanceFilter"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setupDistanceFrame()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.setButtonState(isEnabled: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(mapView,mapBlockerView,bottomView)
        bottomView.addSubviews(placeUpperLabel,markerPinIconImageView,dongAddressLabel,nextButton)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(300)
        }
        mapBlockerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(300)
        }
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(350)
            make.bottom.equalToSuperview()
        }
        placeUpperLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        markerPinIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(dongAddressLabel.snp.centerY)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(24)
        }
        dongAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(markerPinIconImageView.snp.trailing).offset(4)
            make.top.equalTo(placeUpperLabel.snp.bottom).offset(12)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    private func setupDistanceFrame() {
        let distanceSliderFrame = UIView()
        bottomView.addSubview(distanceSliderFrame)
        let sliderLine = createLineView(color: .gray300, height: 3)
        distanceSliderFrame.addSubview(sliderLine)
        distanceSliderFrame.snp.makeConstraints { make in
            make.top.equalTo(dongAddressLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(28)
        }
        sliderLine.snp.makeConstraints { make in
            make.centerY.equalTo(distanceSliderFrame.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(3)
        }
        setupDistanceSelection(sliderLine: sliderLine, container: distanceSliderFrame)
    }
    
    func setupMap(initialPosition: NMGLatLng, dongAddress: String) {
        self.initialPosition = initialPosition
        self.dongAddressLabel.text = dongAddress
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialPosition, zoomTo: 17)
        mapView.mapView.moveCamera(cameraUpdate)
        mapView.showScaleBar = false
        mapView.showZoomControls = false
        mapView.isUserInteractionEnabled = false
        centerMarker.position = initialPosition
        centerMarker.mapView = mapView.mapView
    }
    
    private func setupDistanceSelection(sliderLine: UIView, container: UIView) {
        let selectionData: [(text: String, positionMultiplier: CGFloat)] = [
            ("우리 동네\n(500m 이내)", 0),
            ("가까운동네\n(1km)", 0.5),
            ("먼동네\n(1.5km)", 1)
        ]
        
        DispatchQueue.main.async {
            sliderLine.layoutIfNeeded()
            let sliderWidth = sliderLine.frame.width
            
            for (index, data) in selectionData.enumerated() {
                let isSelected = index == self.selectedDistanceIndex
                
                let touchArea = UIView()
                touchArea.tag = index
                touchArea.isUserInteractionEnabled = true
                container.addSubview(touchArea)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDistanceTap(_:)))
                touchArea.addGestureRecognizer(tapGesture)
                
                let selectionDot = UIView()
                selectionDot.backgroundColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                selectionDot.layer.cornerRadius = isSelected ? 12 : 6
                touchArea.addSubview(selectionDot)
                self.distanceDots.append(selectionDot)
                
                let label = UILabel()
                label.textColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
                label.textAlignment = .center
                label.numberOfLines = 0
                label.text = data.text
                touchArea.addSubview(label)
                self.distanceLabels.append(label)
                
                touchArea.snp.makeConstraints { make in
                    make.centerX.equalTo(sliderLine.snp.leading).offset(data.positionMultiplier * sliderWidth)
                    make.centerY.equalTo(sliderLine)
                    make.width.equalTo(80)
                    make.height.equalTo(80)
                }
                
                selectionDot.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalTo(sliderLine)
                    make.size.equalTo(isSelected ? CGSize(width: 24, height: 24) : CGSize(width: 12, height: 12))
                }
                
                label.snp.makeConstraints { make in
                    make.top.equalTo(sliderLine.snp.bottom).offset(14)
                    make.centerX.equalTo(selectionDot)
                }
            }
        }
    }
    
    @objc private func handleDistanceTap(_ sender: UITapGestureRecognizer) {
        guard let tappedDot = sender.view else { return }
        let newIndex = tappedDot.tag
        updateDistanceSelection(selectedIndex: newIndex)
    }

    private func updateDistanceSelection(selectedIndex: Int) {
        selectedDistanceIndex = selectedIndex
        self.zoomMapview()
        for (index, dot) in distanceDots.enumerated() {
            let isSelected = index == selectedDistanceIndex
            let newSize: CGFloat = isSelected ? 24 : 12

            UIView.animate(withDuration: 0.2, animations: {
                dot.backgroundColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                dot.snp.updateConstraints { make in
                    make.size.equalTo(CGSize(width: newSize, height: newSize))
                }
                dot.layer.cornerRadius = newSize / 2
                if index < self.distanceLabels.count {
                    self.distanceLabels[index].textColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                }
                dot.superview?.layoutIfNeeded()
            })
        }
    }
    
    private func createLineView(color: UIColor, height: CGFloat) -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = color
        return lineView
    }
    
    private func zoomMapview() {
        let zoomLevel: Double = {
            switch self.selectedDistanceIndex {
            case 0: return 17
            case 1: return 16
            default: return 15
            }
        }()
        let cameraUpdate = NMFCameraUpdate(zoomTo: zoomLevel)
        cameraUpdate.animation = .easeOut
        mapView.mapView.moveCamera(cameraUpdate)
    }
    
    @objc private func nextButtonTapped() {
        if let dongAddress = dongAddressLabel.text, let lat = initialPosition?.lat, let lng = initialPosition?.lng {
            delegate?.didTapNextButton(dongAddress: dongAddress, latitude: lat, longitude: lng)
        }
    }
}
