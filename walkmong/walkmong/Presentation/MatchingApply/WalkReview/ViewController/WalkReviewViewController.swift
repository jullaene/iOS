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
        showLoading()
        Task {
            do {
                let response = try await reviewService.getReviewToOwnerList()
                print("Decoded Response: \(response)")
                
                let mappedData = response.data.map { review in
                    DogReviewModel(
                        profileData: .init(
                            image: URL(string: review.reviewerProfile),
                            reviewerId: review.reviewer,
                            walkDate: formatDate(review.walkingDay)
                        ),
                        circleTags: [("사회성", mapTag(for: review.sociality)),
                                     ("활동량", mapTag(for: review.activity)),
                                     ("공격성", mapTag(for: review.aggressiveness))],
                        photos: review.images.compactMap { URL(string: $0) },
                        reviewText: review.content,
                        totalRating: 0,
                        tags: []
                    )
                }
                walkReviewView.configure(with: mappedData)
                self.hideLoading()
            } catch {
                self.hideLoading()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func mapTag(for value: String) -> String {
        switch value {
        case "PEOPLE_FRIENDLY": return "#사람 좋아함"
        case "DOG_FRIENDLY": return "#강아지 좋아함"
        case "SHY": return "#낯가림 있음"
        case "PLAYFUL": return "#애교 많음"
        case "GUARDED": return "#경계심 심함"
        case "RUNNING_CONSTANTLY": return "#계속 뜀"
        case "RUNNING_OCCASIONALLY": return "#가끔 뜀"
        case "WALKING_FAST": return "#빠르게 걸음"
        case "WALKING_SLOWLY": return "#천천히 걸음"
        case "FREQUENTLY_STOPPING": return "#자주 멈춤"
        case "DOCILE": return "#온순함"
        case "OCCASIONAL_BARKING": return "#가끔 짖음"
        case "FREQUENT_BARKING": return "#자주 짖음"
        case "BITING": return "#물려고 함"
        case "NIPPING": return "#입질 있음"
        default: return "#알 수 없음"
        }
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
