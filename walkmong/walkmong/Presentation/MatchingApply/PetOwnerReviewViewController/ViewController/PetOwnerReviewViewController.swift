//
//  PetOwnerReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

extension Notification.Name {
    static let ratingUpdated = Notification.Name("ratingUpdated")
}

class PetOwnerReviewViewController: UIViewController {
    private let petOwnerReviewView = PetOwnerReviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(petOwnerReviewView)
        
        petOwnerReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addCustomNavigationBar(
            titleText: "산책 후기 쓰기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 52
        petOwnerReviewView.setNavigationBarHeight(navigationBarHeight)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateButtonStates),
            name: .ratingUpdated,
            object: nil
        )
    }
    
    @objc private func updateButtonStates() {
        let allRated = petOwnerReviewView.areAllRatingsFilled()
        petOwnerReviewView.updateButtonStates(isAllRated: allRated)
    }
}
