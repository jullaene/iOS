//
//  SupportRequestViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit

class SupportRequestViewController: UIViewController {

    private let supportRequestView = SupportRequestView()

    override func loadView() {
        super.loadView()
        self.view = supportRequestView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .white
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.tabBar.isHidden = true
        }

        addCustomNavigationBar(
            titleText: "산책 지원 요청하기",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
        
        addProgressBar(currentStep: 1, totalSteps: 4)
    }
    
    private func setupActions() {
        supportRequestView.actionButton.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
    }

    @objc private func handleActionButtonTapped() {
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
}
