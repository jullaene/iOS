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
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: nil)
    }
}
