//
//  WalkReviewViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

class WalkReviewViewController: UIViewController {

    private let walkReviewView = WalkReviewView()

    override func loadView() {
        self.view = walkReviewView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavigationBar()
        setupTopSafeAreaBackground()
        configureMockData()
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

        safeAreaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    private func configureMockData() {
        let mockData: [DogReviewModel] = [
            DogReviewModel(
                profileData: .init(
                    image: nil,
                    reviewerId: "멍멍사랑",
                    walkDate: "2024년 12월 1일 산책 진행"
                ),
                circleTags: [("사회성", "#낯가림 있어요"), ("활동량", "#활발해요"), ("공격성", "#안짖어요")],
                photos: [UIImage(named: "defaultImage")].compactMap { $0 },
                reviewText: "정말 즐거운 산책이었습니다.",
                totalRating: 4.5, // 총평점
                tags: ["친절한", "활동적인"] // 태그
            ),
            DogReviewModel(
                profileData: .init(
                    image: nil,
                    reviewerId: "강아지왕",
                    walkDate: "2024년 11월 30일 산책 진행"
                ),
                circleTags: [("사회성", "#친근해요"), ("활동량", "#조용해요"), ("공격성", "#온순해요")],
                photos: [UIImage(named: "defaultImage")].compactMap { $0 },
                reviewText: """
                    강아지가 너무 예쁘고 잘 훈련되어 있어 산책하는 내내 즐거웠습니다.
                    다음에도 꼭 다시 함께 하고 싶어요. 정말 최고의 경험이었습니다!
                    """,
                totalRating: 5.0, // 총평점
                tags: ["조용한", "훈련된"] // 태그
            ),
            DogReviewModel(
                profileData: .init(
                    image: UIImage(named: "profile2"),
                    reviewerId: "산책광",
                    walkDate: "2024년 11월 28일 산책 진행"
                ),
                circleTags: [("사회성", "#차분해요"), ("활동량", "#산책 즐겨요"), ("공격성", "#안짖어요")],
                photos: [
                    UIImage(named: "defaultImage"),
                    UIImage(named: "defaultImage")
                ].compactMap { $0 },
                reviewText: nil,
                totalRating: nil, // 총평점
                tags: ["차분한", "산책 즐기는"] // 태그
            ),
            DogReviewModel(
                profileData: .init(
                    image: nil,
                    reviewerId: "조용조용",
                    walkDate: "2024년 11월 27일 산책 진행"
                ),
                circleTags: [("사회성", "#낯가림 있어요"), ("활동량", "#산책 즐겨요"), ("공격성", "#온순해요")],
                photos: [],
                reviewText: nil,
                totalRating: 3.5, // 총평점
                tags: ["조용한", "온순한"] // 태그
            ),
            DogReviewModel(
                profileData: .init(
                    image: nil,
                    reviewerId: "행복개님",
                    walkDate: "2024년 11월 25일 산책 진행"
                ),
                circleTags: [("사회성", "#낯가림 있어요"), ("활동량", "#활발해요"), ("공격성", "#조용해요")],
                photos: [
                    UIImage(named: "defaultImage"),
                    UIImage(named: "defaultImage")
                ].compactMap { $0 },
                reviewText: """
                    강아지와 함께 한 시간이 너무 좋았습니다.
                    주인분도 친절하게 설명해 주셔서 아주 만족스러웠습니다.
                    꼭 다시 참여하고 싶습니다!
                    """,
                totalRating: 4.8, // 총평점
                tags: ["친절한", "조용한"] // 태그
            )
        ]

        walkReviewView.configure(with: mockData)
    }
}
