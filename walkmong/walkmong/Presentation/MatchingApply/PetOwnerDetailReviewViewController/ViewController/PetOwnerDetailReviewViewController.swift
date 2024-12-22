//
//  PetOwnerDetailReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

import UIKit

class PetOwnerDetailReviewViewController: UIViewController {
    private let detailReviewView = PetOwnerDetailReviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        disableSwipeBackGesture()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(detailReviewView)
        
        detailReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addCustomNavigationBar(
            titleText: "자세한 후기 작성",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }

    // MARK: - Disable Swipe Back Gesture
    private func disableSwipeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
