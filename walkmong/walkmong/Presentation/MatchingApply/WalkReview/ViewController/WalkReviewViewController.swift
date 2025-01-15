//
//  WalkReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

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
        tabBarController?.tabBar.isHidden = true
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
                // 서버 응답 데이터 가져오기
                let response = try await reviewService.getReviewToWalkerList()
                
                // 디코딩된 응답 출력
                print("Decoded Response: \(response)")
                
                // 데이터 매핑 및 뷰 업데이트
                let mappedData = response.data.map { review in
                    DogReviewModel(
                        profileData: .init(
                            image: review.profiles.first.flatMap { UIImage(named: $0) }, // 프로필 이미지
                            reviewerId: "\(review.ownerName)의 \(review.dogName)", // 리뷰 작성자 정보
                            walkDate: formatDate(review.walkingDay) // 날짜 포맷
                        ),
                        circleTags: [],
                        photos: review.profiles.compactMap { UIImage(named: $0) },
                        reviewText: review.content,
                        totalRating: calculateAverageRating(review), // 평점 평균
                        tags: review.hashtags // 태그
                    )
                }
                walkReviewView.configure(with: mappedData)
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted: \(context.debugDescription)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found: \(context.debugDescription)")
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch: \(context.debugDescription)")
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found: \(context.debugDescription)")
            } catch {
                print("Unknown error: \(error.localizedDescription)")
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
        return DateFormatter.display.string(from: date)
    }
}
