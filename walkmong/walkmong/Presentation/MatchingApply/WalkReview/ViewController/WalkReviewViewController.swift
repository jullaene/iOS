//
//  WalkReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import Kingfisher

class WalkReviewViewController: UIViewController {

    private let walkReviewView = WalkReviewView()
    private let reviewService = ReviewService()

    override func loadView() {
        self.view = walkReviewView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupTopSafeAreaBackground()
        fetchReviewData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }

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

    private func setupTopSafeAreaBackground() {
        let safeAreaBackgroundView = UIView()
        safeAreaBackgroundView.backgroundColor = .gray100
        view.addSubview(safeAreaBackgroundView)

        safeAreaBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    private func fetchReviewData() {
        Task {
            do {
                let response = try await reviewService.getReviewToWalkerList()
                print("Decoded Response: \(response)")
                
                let mappedData = response.data.map { review in
                    DogReviewModel(
                        profileData: .init(
                            image: review.profiles?.first.flatMap { URL(string: $0) },
                            reviewerId: review.ownerName,
                            walkDate: formatDate(review.walkingDay)
                        ),
                        circleTags: [],
                        photos: review.profiles?.compactMap { URL(string: $0) } ?? [],
                        reviewText: review.content,
                        totalRating: calculateAverageRating(review),
                        tags: review.hashtags
                    )
                }
                walkReviewView.configure(with: mappedData)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func calculateAverageRating(_ review: ReviewToWalker) -> Float {
        let ratings = [review.photoSharing, review.attitude, review.taskCompletion, review.timePunctuality, review.communication]
        let total = ratings.reduce(0, +)
        return total / Float(ratings.count)
    }

    private func formatDate(_ dateString: String) -> String {
        guard let date = ISO8601DateFormatter.date(from: dateString) else { return dateString }
        let formattedDate = Date.formattedDate(date, format: "yyyy년 MM월 dd일")
        return "\(formattedDate) 산책 진행"
    }
}
