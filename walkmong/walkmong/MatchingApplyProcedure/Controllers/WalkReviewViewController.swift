//
//  WalkReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

class WalkReviewViewController: UIViewController {

    // MARK: - Properties
    private let walkReviewView = WalkReviewView()
    private let topSafeAreaBackgroundView = UIView() // 상단 safeArea 배경 뷰 추가

    // MARK: - Lifecycle
    override func loadView() {
        // 컨트롤러의 메인 뷰로 WalkReviewView를 설정
        self.view = walkReviewView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupTopSafeAreaBackground() // SafeArea 배경 설정
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true // 탭 바 숨기기
    }

    // MARK: - Setup Custom Navigation Bar
    private func setupCustomNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .gray100
        )
    }
    
    // MARK: - Setup Top Safe Area Background
    private func setupTopSafeAreaBackground() {
        topSafeAreaBackgroundView.backgroundColor = .gray100
        view.addSubview(topSafeAreaBackgroundView)
        
        // Constraints for the background view to cover the top safe area
        topSafeAreaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSafeAreaBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topSafeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSafeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSafeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
