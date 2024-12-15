//
//  CustomMarker.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit
import NMapsMap

final class CustomMarker: NMFMarker {
    
    // MARK: - UI & Layout
    
    let startInfoWindow = NMFInfoWindow()
    
    // MARK: - initialization
    
    override init() {
        super.init()
        setUI()
        setInfoWindow()
    }
    
    private func setUI() {
        self.iconImage = NMFOverlayImage(image: UIImage.markerIcon)
        
        self.width = CGFloat(47)
        self.height = CGFloat(60)
        
        self.anchor = CGPoint(x: 0.5, y: 1)
        
        self.iconPerspectiveEnabled = false
    }
    private func setInfoWindow() {
        startInfoWindow.dataSource = self
    }
    
    func showInfoWindow() {
        startInfoWindow.open(with: self)
    }
    
    func hideInfoWindow() {
        startInfoWindow.close()
    }
}

extension CustomMarker: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        // 마커 위에 보여줄 InfoView 이미지 리턴
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 212, height: 30))
        imageView.image = .markerInfoWindow
        return imageView
    }
}
