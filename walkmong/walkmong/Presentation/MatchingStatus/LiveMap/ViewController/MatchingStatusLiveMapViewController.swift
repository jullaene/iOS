//
//  MatchingStatusLiveMapViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit
import CoreLocation

final class MatchingStatusLiveMapViewController: UIViewController {
    
    private lazy var locationManager = CLLocationManager()
    private var Location_Address: CLLocation?
    private var lastMyLocation: CLLocation?
    private let isWalker: Bool
    private let mapView = MatchingStatusLiveMapView()

    init(isWalker: Bool) {
        self.isWalker = isWalker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setConstraints()
        addCustomNavigationBar(titleText: "진행중인 산책", showLeftBackButton: true, showLeftCloseButton: false, showRightCloseButton: false, showRightRefreshButton: true, delegate: self)
        if isWalker {
            setToGetCurrentLocation()
        }
        refreshLocation()
    }
    
    private func addSubview() {
        view.addSubviews(mapView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(60)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    private func showSheet(dogNickname: String, walkerNickname: String? = nil) {
        let viewControllerToPresent = MatchingStatusLiveMapModalViewController(dogNickname: dogNickname, walkerNickname: walkerNickname)
        viewControllerToPresent.modalPresentationStyle = .pageSheet
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            
            return 350 - safeAreaBottom
        }
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [customDetent, .large()] // 사용 가능한 높이 설정
            sheet.selectedDetentIdentifier = customDetent.identifier // 초기 높이 설정
            sheet.prefersGrabberVisible = true // Grabber 표시
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true // 스크롤로 시트 확장 가능

            // 완전히 내려가지 않도록 설정
            sheet.prefersEdgeAttachedInCompactHeight = false // 작은 화면에서도 시트 고정
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true // 스크롤로 확장만 허용
            sheet.largestUndimmedDetentIdentifier = .large // 배경 흐림 효과 적용
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func setToGetCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
    }
}

extension MatchingStatusLiveMapViewController: NavigationBarDelegate {
    func rightButtonTapped() {
        refreshLocation()
    }
    
    private func refreshLocation() {
        //TODO: 위치 갱신 로직
        if isWalker {
            showSheet(dogNickname: "반려견 이름")
        }else {
            showSheet(dogNickname: "반려견 이름", walkerNickname: "산책자 이름")
        }
    }
}

extension MatchingStatusLiveMapViewController {
    //TODO: 게시글 상세 정보 API 호출
}

extension MatchingStatusLiveMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {
            return
        }
        Location_Address = location
        print("위도 : ",lastMyLocation?.coordinate.latitude," 경도 : ",lastMyLocation?.coordinate.longitude)
    }
}
