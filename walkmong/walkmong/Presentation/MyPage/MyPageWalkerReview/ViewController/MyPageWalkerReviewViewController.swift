//
//  MyPageWalkerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

final class MyPageWalkerReviewViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var myPageReportView = MyPageWalkerReviewView()
    private var dimView: UIView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }

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
    
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(myPageReportView)
        myPageReportView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
