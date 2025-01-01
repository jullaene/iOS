//
//  WalkerDetailReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/1/25.
//

import UIKit
import SnapKit

final class WalkerDetailReviewViewController: UIViewController {

    // MARK: - Properties
    private let reviewPhotoView = ReviewPhotoView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        disableBackSlideGesture()
    }

    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(reviewPhotoView)
        reviewPhotoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52+23)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "자세한 후기 쓰기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }

    private func disableBackSlideGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
