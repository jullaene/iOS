//
//  WalkReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

class WalkReviewViewController: UIViewController {

    // MARK: - Properties
    private let contentView = WalkReviewView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHomeFilterButtonPosition()
    }

    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .gray100
        )
    }

    // MARK: - Adjust Button Position
    private func setupHomeFilterButtonPosition() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        contentView.updateHomeFilterButtonPosition(navigationBarHeight: navigationBar.frame.height)
    }
}
