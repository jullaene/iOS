//
//  MatchingStatusLiveMapViewController.swift
//  walkmong
//
//  Created by 황채웅 on 1/16/25.
//

import UIKit
import CoreLocation
import NMapsMap

final class MatchingStatusLiveMapViewController: UIViewController {
    
    private lazy var locationManager = CLLocationManager()
    private var Location_Address: CLLocation?
    private var lastMyLocation: CLLocation?
    private var viewControllerToPresent: MatchingStatusLiveMapModalViewController?
    private let isWalker: Bool
    private let boardId: Int
    private let mapView = MatchingStatusLiveMapView()
    private let boardService = BoardService()
    private let applyService = ApplyService()
    private var applyDetail: ApplyDetail?

    init(isWalker: Bool, boardId: Int) {
        self.boardId = boardId
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
        getBoardDetail()
        refreshLocation()
    }
    
    private func addSubview() {
        view.addSubviews(mapView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(60)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-350)
        }
    }
    private func showSheet(dogNickname: String, walkerNickname: String? = nil) {
        viewControllerToPresent = MatchingStatusLiveMapModalViewController(dogNickname: dogNickname, walkerNickname: walkerNickname)
        viewControllerToPresent?.modalPresentationStyle = .pageSheet
        viewControllerToPresent?.delegate = self
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            
            return 350 - safeAreaBottom
        }
        if let sheet = viewControllerToPresent?.sheetPresentationController {
            sheet.detents = [customDetent, .large()] // 사용 가능한 높이 설정
            sheet.selectedDetentIdentifier = customDetent.identifier // 초기 높이 설정
            sheet.prefersGrabberVisible = true // Grabber 표시
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true // 스크롤로 시트 확장 가능

            sheet.delegate = self
            sheet.prefersEdgeAttachedInCompactHeight = true // 작은 화면에서도 시트 고정
            sheet.largestUndimmedDetentIdentifier = .large // 배경 흐림 효과 적용
        }
        if let vc = viewControllerToPresent {
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func setToGetCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
}

extension MatchingStatusLiveMapViewController: NavigationBarDelegate {
    func rightButtonTapped() {
        refreshLocation()
    }
    
    private func refreshLocation() {
        if isWalker {
            fetchCurrentLocation() // 상대방에게 위치 전송
        }else {
            getCurrentLocation() // 상대방 위치 업데이트
        }
    }
}

extension MatchingStatusLiveMapViewController {
    
    private func getBoardDetail() {
        Task {
            do {
                let response = try await applyService.getApplyDetail(boardId: boardId)
                applyDetail = response.data
                if let applyDetail = applyDetail {
                    updateModalView(data: applyDetail)
                }
            }catch let error as NetworkError{
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("매칭 상세 조회 실패")
                    .setSubTitleText(error.message)
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }catch {
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("매칭 상세 조회 실패")
                    .setSubTitleText("네트워크 상태를 확인해주세요")
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
    }
    
    private func fetchCurrentLocation() {
        guard let lat = Location_Address?.coordinate.latitude,
              let lng = Location_Address?.coordinate.longitude else { return }

        let taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        Task {
            do {
                _ = try await boardService.saveCurrentLocation(boardId: boardId, latitude: lat, longitude: lng)
                mapView.updateLocation(position: NMGLatLng(lat: lat, lng: lng))
                print("위치 저장 성공: \(lat), \(lng)")
            } catch let error as NetworkError {
                print("위치 저장 실패: \(error.message)")
            }
            UIApplication.shared.endBackgroundTask(taskIdentifier)
        }
    }

    private func updateModalView(data: ApplyDetail) {
        DispatchQueue.main.async { [self] in
            if isWalker {
                showSheet(dogNickname: data.dogName)
            }else {
                showSheet(dogNickname: data.dogName, walkerNickname: data.walkerNickname)
            }
            if let vc = viewControllerToPresent {
                vc.setContent(requestMessage: data.walkRequest, referenceMessage: data.walkNote, additionalMessage: data.additionalRequest)
                let timeDifference = calculateTimeDifference(startTime: data.startTime, endTime: data.endTime)
                vc.setTime(timePast: timeDifference.timePast, timeLeft: timeDifference.timeLeft)
            }else {
            }
        }

    }
    
    private func getCurrentLocation() {
        Task {
            do {
                let response = try await boardService.getCurrentLocation(boardId: boardId)
                mapView.updateLocation(position: NMGLatLng(lat: response.data.latitude, lng: response.data.longitude))
            }catch let error as NetworkError {
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("위치 공유 실패")
                    .setSubTitleText(error.message)
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
    }
    
}

extension MatchingStatusLiveMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Location_Address = location
        lastMyLocation = location
        if let data = applyDetail {
            updateModalView(data: data) // 남은 시간 업데이트
        }
        fetchCurrentLocation()
    }

}

extension MatchingStatusLiveMapViewController: UISheetPresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}

extension MatchingStatusLiveMapViewController {
    private func calculateTimeDifference(startTime: String, endTime: String) -> (timePast: Int, timeLeft: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // 현재 시간
        let now = Date()
        let calendar = Calendar.current
        
        // 문자열로부터 Date 생성
        guard let startDate = dateFormatter.date(from: startTime),
              let endDate = dateFormatter.date(from: endTime) else {
            return (0,0)
        }
        
        // 현재 시간의 "HH:mm"으로만 비교할 수 있도록 오늘 날짜와 합침
        let nowComponents = calendar.dateComponents([.hour, .minute], from: now)
        let todayStartTime = calendar.date(bySettingHour: calendar.component(.hour, from: startDate),
                                           minute: calendar.component(.minute, from: startDate),
                                           second: 0,
                                           of: now) ?? startDate
        let todayEndTime = calendar.date(bySettingHour: calendar.component(.hour, from: endDate),
                                         minute: calendar.component(.minute, from: endDate),
                                         second: 0,
                                         of: now) ?? endDate
        
        // 경과 시간 (분 단위)
        let minutesPast = calendar.dateComponents([.minute], from: todayStartTime, to: now).minute ?? 0
        // 남은 시간 (분 단위)
        let minutesLeft = calendar.dateComponents([.minute], from: now, to: todayEndTime).minute ?? 0
        
        // 결과 생성
        let timePastText = minutesPast > 0 ? minutesPast: 0
        let timeLeftText = minutesLeft > 0 ? minutesLeft : 0
        
        return (timePastText, timeLeftText)
    }
}

extension MatchingStatusLiveMapViewController: MatchingStatusLiveMapModalViewControllerDelegate {
    func didTapContactButton() {
        let nextVC = WalktalkListViewController()
        self.navigationController?.popToViewController(nextVC, animated: true)
    }
    
    func didTapEndButton() {
        Task {
            do {
                _ = try await boardService.changeStatus(status: "AFTER", boardId: boardId)
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("산책 종료")
                    .setSubTitleText("후기를 작성해주세요")
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .setSingleButtonAction({
                        let nextVC = MatchingStatusListViewController()
                        self.navigationController?.popToViewController(nextVC, animated: true)
                    })
                    .showAlertView()
            }catch let error as NetworkError {
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: self)
                    .setTitleState(.useTitleAndSubTitle)
                    .setTitleText("산책 종료 실패")
                    .setSubTitleText(error.message)
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
    }
}
