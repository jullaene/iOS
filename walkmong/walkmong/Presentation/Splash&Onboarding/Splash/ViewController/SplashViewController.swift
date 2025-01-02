//
//  SplashViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/2/25.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let splashView = SplashView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBlue
        navigateToOnboarding()
    }
    
    // MARK: - Navigation
    private func navigateToOnboarding() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            let onboardingVC = OnboardingViewController()
            onboardingVC.modalPresentationStyle = .fullScreen
            self?.present(onboardingVC, animated: false, completion: nil)
        }
    }
}
