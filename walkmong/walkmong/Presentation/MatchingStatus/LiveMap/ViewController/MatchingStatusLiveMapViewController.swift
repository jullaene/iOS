//
//  MatchingStatusLiveMapViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit

final class MatchingStatusLiveMapViewController: UIViewController {
    
    private let mapView = MatchingStatusLiveMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "진행중인 산책", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: true)
    }
    
    private func addSubview() {
        view.addSubviews(mapView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
