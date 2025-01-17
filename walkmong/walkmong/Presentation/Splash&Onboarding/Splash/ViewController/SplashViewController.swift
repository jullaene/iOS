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
        navigateToNextScreen()
    }
    
    // MARK: - Navigation
        private func navigateToNextScreen() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self else { return }
                
                if AuthManager.shared.isLoggedIn() {
                    // 로그인 상태: 메인 화면으로 이동
                    let mainTabBarController = MainTabBarController()
                    self.transitionToRootViewController(mainTabBarController)
                } else {
                    // 비로그인 상태: 온보딩 화면으로 이동
                    let onboardingVC = OnboardingViewController()
                    onboardingVC.modalPresentationStyle = .fullScreen
                    self.present(onboardingVC, animated: true, completion: nil)
                }
            }
        }
        
        private func transitionToRootViewController(_ viewController: UIViewController) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate else {
                return
            }
            
            let window = delegate.window
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
    }
