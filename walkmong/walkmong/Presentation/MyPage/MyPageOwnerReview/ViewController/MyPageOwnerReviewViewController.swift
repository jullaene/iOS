//
//  MyPageOwnerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/18/24.
//

import UIKit

class MyPageOwnerReviewViewController: UIViewController {
    
    // MARK: - Properties
    private let ownerReviewView = MyPageOwnerReviewView()
    private var dimView: UIView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        addCustomNavigationBar(titleText: "반려인 후기",
                               showLeftBackButton: true,
                               showLeftCloseButton: false,
                               showRightCloseButton: false,
                               showRightRefreshButton: false,
                               backgroundColor: .gray100
        )
    }
    
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(ownerReviewView)
        ownerReviewView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
