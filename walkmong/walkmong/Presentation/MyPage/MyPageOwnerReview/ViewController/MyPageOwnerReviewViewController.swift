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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
    func getReviewToWalkerList() async {
        let reviewService = ReviewService()
        Task {
            do {
                let response = try await reviewService.getReviewToWalkerList()
                print("API Response: \(response)")
                let reviews = response.data
                print("Reviews Count: \(reviews.count)")
                
                DispatchQueue.main.async {
                    for review in reviews {
                        print("Review ID: \(review.reviewToWalkerId)")
                        print("Owner Name: \(review.ownerName)")
                        print("Dog Name: \(review.dogName)")
                        print("Content: \(review.content)")
                        print("Hashtags: \(review.hashtags.joined(separator: ", "))")
                    }
                }
            } catch {
                print("Error fetching reviews: \(error)")
            }
        }
    }
    
}
