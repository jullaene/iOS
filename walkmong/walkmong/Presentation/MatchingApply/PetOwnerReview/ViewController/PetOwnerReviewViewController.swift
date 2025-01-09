//
//  PetOwnerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

extension Notification.Name {
    static let ratingUpdated = Notification.Name("ratingUpdated")
}

class PetOwnerReviewViewController: UIViewController {
    // MARK: - UI Elements
    private var navigationBarHeight: CGFloat = 52
    
    private let petOwnerReviewView = PetOwnerReviewView()
    private let networkProvider = NetworkProvider<ReviewAPI>()
    
    private var walkerId: [Int64] = []
    private var boardId: [Int64] = []
    
    init(walkerId: [Int64], boardId: [Int64]) {
        self.walkerId = walkerId
        self.boardId = boardId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.walkerId = []
        self.boardId = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservers()
        setupSendReviewButtonAction()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(petOwnerReviewView)
        
        petOwnerReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addCustomNavigationBar(
            titleText: "산책 후기 쓰기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 52
        petOwnerReviewView.setNavigationBarHeight(navigationBarHeight)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateButtonStates),
            name: .ratingUpdated,
            object: nil
        )
    }
    
    private func setupSendReviewButtonAction() {
        petOwnerReviewView.sendReviewButton.addTarget(
            self,
            action: #selector(didTapSendReviewButton),
            for: .touchUpInside
        )
    }
    
    @objc private func updateButtonStates() {
        let allRated = petOwnerReviewView.areAllRatingsFilled()
        petOwnerReviewView.updateButtonStates(isAllRated: allRated)
        
        petOwnerReviewView.detailedReviewButton.addTarget(self, action: #selector(didTapDetailedReviewButton), for: .touchUpInside)
    }

    @objc private func didTapDetailedReviewButton() {
        guard petOwnerReviewView.areAllRatingsFilled() else {
            showAlert(message: "모든 평가 항목을 채워주세요.")
            return
        }
        
        guard let ratings = petOwnerReviewView.collectRatings() else {
            showAlert(message: "별점 데이터를 수집하지 못했습니다.")
            return
        }
        
        let basicRatings = ratings.mapValues { Float($0) }
        
        let detailReviewVC = PetOwnerDetailReviewViewController(
            walkerId: walkerId,
            boardId: boardId,
            basicRatings: basicRatings
        )
        navigationController?.pushViewController(detailReviewVC, animated: true)
    }

    @objc private func didTapSendReviewButton() {
        guard petOwnerReviewView.areAllRatingsFilled() else {
            showAlert(message: "모든 평가 항목을 채워주세요.")
            return
        }

        let requestBody = collectBasicReviewData()
        Task {
            await sendReviewData(requestBody: requestBody)
        }
    }

    private func collectBasicReviewData() -> [String: Any] {
        guard let ratings = petOwnerReviewView.collectRatings() else {
            showAlert(message: "별점 데이터를 수집하지 못했습니다.")
            return [:]
        }

        return [
            "walkerId": walkerId,
            "boardId": boardId,
            "timePunctuality": ratings["timePunctuality"] ?? 0.0,
            "communication": ratings["communication"] ?? 0.0,
            "attitude": ratings["attitude"] ?? 0.0,
            "taskCompletion": ratings["taskCompletion"] ?? 0.0,
            "photoSharing": ratings["photoSharing"] ?? 0.0
        ]
    }
    
    private func sendReviewData(requestBody: [String: Any]) async {
        print("전송할 데이터 (기본 리뷰):")
        requestBody.forEach { key, value in
            print("\(key): \(value)")
        }
        
        do {
            let response: APIResponse<EmptyDTO> = try await networkProvider.request(
                target: .registerReview(requestBody: requestBody),
                responseType: APIResponse<EmptyDTO>.self
            )
            print("후기 등록 성공: \(response.message)")
            navigateToMatchingViewController()
        } catch {
            showAlert(message: "후기 등록에 실패했습니다. 네트워크를 확인해주세요.")
        }
    }

    private func navigateToMatchingViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        if let mainTabBarController = sceneDelegate.window?.rootViewController as? MainTabBarController {
            mainTabBarController.selectedIndex = 0
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func showAlert(message: String) {
        CustomAlertViewController
            .CustomAlertBuilder(viewController: self)
            .setTitleState(.useTitleOnly)
            .setButtonState(.singleButton)
            .setTitleText("알림")
            .setSubTitleText(message)
            .setButtonState(.singleButton)
            .setSingleButtonTitle("확인")
            .showAlertView()
    }
}
