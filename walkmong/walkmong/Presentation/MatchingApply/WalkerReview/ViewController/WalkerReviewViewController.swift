//
//  WalkerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

final class WalkerReviewViewController: UIViewController {

    // MARK: - Properties
    private let walkerReviewView = WalkerReviewView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }

    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(walkerReviewView)
        walkerReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기 쓰기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }
}
