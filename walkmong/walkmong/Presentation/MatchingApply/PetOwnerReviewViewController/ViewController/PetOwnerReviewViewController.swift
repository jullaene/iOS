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
    private let networkManager = NetworkManager()
    
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

        let requestBody: [String: Any] = ["testKey": "testValue"]
        sendReviewDataToServer(requestBody: requestBody)
    }

    private func sendReviewDataToServer(requestBody: [String: Any]) {
        networkManager.fetchBoardDetail(boardId: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("후기가 성공적으로 등록되었습니다.")
                DispatchQueue.main.async {
                    self.navigateToMatchingViewController()
                }
            case .failure(let error):
                print("후기를 등록하지 못했습니다. 오류: \(error.localizedDescription)")
            }
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
