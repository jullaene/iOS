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
    private let reviewService = ReviewService()
    private let dogService = DogService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        loadInitialData()
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
        view.addSubview(ownerReviewView)
        ownerReviewView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        Task {
            await fetchDogFilters()
            await fetchReviewData()
        }
    }
    
    private func fetchReviewData() {
        showLoading()
        Task {
            do {
                let response = try await reviewService.getReviewToWalkerList()

                let reviews = response.data

                let mappedData = reviews.map { review in
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
                        tags: review.hashtags.compactMap { MemberWalkingTagEnum(rawValue: $0)?.description }
                    )
                }

                let radarScores: [CGFloat] = [
                    CGFloat(reviews.first?.photoSharing ?? 0),
                    CGFloat(reviews.first?.attitude ?? 0),
                    CGFloat(reviews.first?.communication ?? 0),
                    CGFloat(reviews.first?.timePunctuality ?? 0),
                    CGFloat(reviews.first?.taskCompletion ?? 0)
                ]
                ownerReviewView.walkReviewTotalRatingView.radarChartView.updateScores(radarScores)

                ownerReviewView.configure(with: mappedData)
                self.hideLoading()
            } catch {
                self.hideLoading()
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func calculateTotalRating(from review: ReviewToWalker) -> Float {
        let ratings = [
            review.photoSharing,
            review.attitude,
            review.taskCompletion,
            review.timePunctuality,
            review.communication
        ]
        return ratings.reduce(0, +) / Float(ratings.count)
    }
    
    private func fetchDogFilters() async {
        do {
            let response = try await dogService.getDogList()
            DispatchQueue.main.async {
                self.ownerReviewView.updateDogFilters(with: response.data)
            }
        } catch {
            handleError(error, message: "강아지 필터 데이터를 불러오는 데 실패했습니다.")
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error, message: String) {
        print("Error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func calculateAverageRating(_ review: ReviewToWalker) -> Float {
        let ratings = [review.photoSharing, review.attitude, review.taskCompletion, review.timePunctuality, review.communication]
        let total = ratings.reduce(0, +)
        return total / Float(ratings.count)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 MM월 dd일"
        return "\(outputFormatter.string(from: date)) 산책 진행"
    }
}
