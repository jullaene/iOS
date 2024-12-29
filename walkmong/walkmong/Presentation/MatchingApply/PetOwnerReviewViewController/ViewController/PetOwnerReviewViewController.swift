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
    private let petOwnerReviewView = PetOwnerReviewView()
    private let networkProvider = NetworkProvider<ReviewAPI>()
    
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
        if petOwnerReviewView.areAllRatingsFilled() {
            let detailReviewVC = PetOwnerDetailReviewViewController()
            navigationController?.pushViewController(detailReviewVC, animated: true)
        }
    }

    @objc private func didTapSendReviewButton() {
        guard petOwnerReviewView.areAllRatingsFilled() else { return }

        let requestBody = collectReviewData()
        Task {
            await sendReviewData(requestBody: requestBody)
        }
    }

    private func collectReviewData() -> [String: Any] {
        return [
            "walkerId": [1],
            "boardId": [1],
            "timePunctuality": 4.5,
            "communication": 4.0,
            "attitude": 5.0,
            "taskCompletion": 4.5,
            "photoSharing": 3.5,
            "hashtags": ["LIKED_BY_DOG", "POLITE"],
            "images": [],
            "content": "좋은 후기 작성 내용"
        ]
    }

    private func sendReviewData(requestBody: [String: Any]) async {
        do {
            let response: APIResponse<EmptyDTO> = try await networkProvider.request(
                target: .registerReview(requestBody: requestBody),
                responseType: APIResponse<EmptyDTO>.self
            )
            print("후기 등록 성공: \(response.message)")
            navigateToMatchingViewController()
        } catch {
            print("후기 등록 실패: \(error.localizedDescription)")
        }
    }

    private func navigateToMatchingViewController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        if let mainTabBarController = sceneDelegate.window?.rootViewController as? MainTabBarController {
            mainTabBarController.selectedIndex = 0
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
