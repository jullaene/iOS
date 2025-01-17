//
//  OnboardingViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/2/25.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let onboardingView = OnboardingView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        onboardingView.nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapNextButton() {
        let currentPage = onboardingView.currentPage
        let totalPages = onboardingView.totalPages

        if currentPage < totalPages - 1 {
            onboardingView.scrollToPage(currentPage + 1)
        } else {
            let mainTabBarController = SignupFirstViewController()
            if let window = UIApplication.shared.keyWindow {
                window.rootViewController = UINavigationController(rootViewController: mainTabBarController)
                window.makeKeyAndVisible()
            }
        }
    }
}
