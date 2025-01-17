//
//  MatchingApplyWalkRequestCautionViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestCautionViewController: UIViewController {

    var requestData: MatchingApplyWalkRequestData?
    
    private let containerView = MatchingApplyWalkRequestView()
    private let cautionView = MatchingApplyWalkRequestCautionView()

    override func loadView() {
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addProgressBar(currentStep: 5, totalSteps: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setupUI() {
        view.backgroundColor = .gray100

        addCustomNavigationBar(
            titleText: "산책 지원 요청",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        
        containerView.middleTitleLabel.text = "주의사항 확인"
        containerView.actionButton.setTitle("산책 지원하기", for: .normal)
        containerView.updateContentView(with: cautionView)
        containerView.actionButton.addTarget(self, action: #selector(handleSubmitButtonTapped), for: .touchUpInside)
        containerView.showWarningSection()
    }

    @objc private func handleSubmitButtonTapped() {
        let alertBuilder = CustomAlertViewController.CustomAlertBuilder(viewController: self)
        alertBuilder
            .setTitleState(.useTitleOnly)
            .setButtonState(.doubleButton)
            .setTitleText("산책 지원을 요청하시겠습니까?")
            .setLeftButtonTitle("아니오")
            .setRightButtonTitle("예")
            .setLeftButtonAction { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .setRightButtonAction { [weak self] in
                self?.submitWalkRequest()
                self?.navigateToMainTabBar()
            }
            .showAlertView()
    }
    
    private func navigateToMainTabBar() {
        if let navigationController = navigationController {
            NotificationCenter.default.post(name: .reloadMatchingView, object: nil)
            
            navigationController.popToRootViewController(animated: true)
        } else {
            let mainTabBarController = MainTabBarController()
            UIApplication.shared.keyWindow?.rootViewController = mainTabBarController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
    
    private func submitWalkRequest() {
        guard let requestData = requestData else {
            print("전송할 데이터가 없습니다.")
            return
        }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        isoFormatter.timeZone = TimeZone.current

        // ISO8601 형식 -> Date 변환
        guard let startDate = isoFormatter.date(from: requestData.startTime),
              let endDate = isoFormatter.date(from: requestData.endTime) else {
            print("ISO8601 형식으로 시간을 변환할 수 없습니다: startTime=\(requestData.startTime), endTime=\(requestData.endTime)")
            showErrorAlert(NSError(domain: "Invalid ISO8601 Format", code: 400, userInfo: nil))
            return
        }

        // Date -> 백엔드 요구 형식으로 변환
        let startTime = Date.formattedDate(startDate, format: "yyyy-MM-dd HH:mm:ss.SSSSSS")
        let endTime = Date.formattedDate(endDate, format: "yyyy-MM-dd HH:mm:ss.SSSSSS")

        print("변환된 startTime: \(startTime), endTime: \(endTime)")
        
        let parameters: [String: Any] = [
            "dogId": requestData.dogId,
            "addressId": requestData.addressId,
            "startTime": startTime,
            "endTime": endTime,
            "locationNegotiationYn": requestData.locationNegotiationYn,
            "preMeetAvailableYn": requestData.preMeetAvailableYn,
            "walkRequest": requestData.walkRequest,
            "walkNote": requestData.walkNote,
            "additionalRequest": requestData.additionalRequest
        ]
        
        print("전송 데이터: \(parameters)")
        
        Task {
            do {
                let response = try await BoardService().registerBoard(parameters: parameters)
                print("등록 성공: \(response)")
            } catch {
                print("등록 실패: \(error)")
                showErrorAlert(error)
            }
        }
    }

    private func showErrorAlert(_ error: Error) {
        let alertBuilder = CustomAlertViewController.CustomAlertBuilder(viewController: self)
        alertBuilder
            .setTitleState(.useTitleAndSubTitle)
            .setButtonState(.singleButton)
            .setTitleText("등록 실패")
            .setSubTitleText("산책 지원 요청 등록에 실패했습니다. 다시 시도해주세요.\n\(error.localizedDescription)")
            .setSingleButtonTitle("확인")
            .showAlertView()
    }
}

extension Notification.Name {
    static let reloadMatchingView = Notification.Name("reloadMatchingView")
}
