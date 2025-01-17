//
//  MatchingStatusApplicantDetailViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusApplicantDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let applicationDetailView = MatchingStatusApplicantDetailView()
    private let myPageView = MyPageView()
    private var matchingData: BoardList?
    private let memberService = MemberService()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        loadData()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(applicationDetailView)
        applicationDetailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 지원서",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
    }
    
    // MARK: - Data Management
    private func loadData() {
        let dogProfileData = BoardList(
            boardId: 1,
            startTime: "2025-01-03 00:32:40",
            endTime: "2025-01-03 14:32:30",
            matchingYn: "Y",
            dogName: "봄별이",
            dogProfile: "https://vetmed.tamu.edu/news/wp-content/uploads/sites/9/2023/05/AdobeStock_472713009-1024x768.jpeg",
            dogGender: "FEMALE",
            breed: "말티즈",
            weight: 4,
            dogSize: "SMALL",
            content: "Helloworld",
            dongAddress: "마포구 공덕동",
            distance: 1000,
            createdAt: "2025-01-02 00:32:40"
        )
        applicationDetailView.configureDogProfileSection(with: dogProfileData)
        
        let applicant = MatchingStatusApplicantInfo(
            ownerProfile: "https://img.freepik.com/free-photo/expressive-asian-girl-posing-indoor_344912-1234.jpg?semt=ais_hybrid",
            ownerName: "홍길동",
            ownerAge: 32,
            ownerGender: "MALE",
            dongAddress: "서울시 강남구",
            distance: 500
        )
        applicationDetailView.configureApplicantsList(with: applicant)
    }
    
    private func fetchUserProfile() {
        Task {
            do {
                let response = try await memberService.getMemberWalking()
                let memberWalking = response.data
                DispatchQueue.main.async {
                    self.myPageView.updateProfileName(memberWalking.name)
                    self.myPageView.updateProfileImage(memberWalking.profile)
                    
                    self.myPageView.updateWalkInfo(
                        dogOwnership: memberWalking.dogOwnership,
                        dogWalkingExperience: memberWalking.dogWalkingExperience,
                        availabilityWithSize: memberWalking.availabilityWithSize
                    )
                    
                    let radarScores: [CGFloat] = [
                        CGFloat(memberWalking.photoSharing),
                        CGFloat(memberWalking.attitude),
                        CGFloat(memberWalking.communication),
                        CGFloat(memberWalking.timePunctuality),
                        CGFloat(memberWalking.taskCompletion)
                    ]
                    self.myPageView.contentViewSection.reviewView.updateWalkerReviewCount(memberWalking.walkerReviewCount)
                    self.myPageView.contentViewSection.reviewView.updateWalkerParticipantCount(memberWalking.walkerReviewCount)
                    self.myPageView.contentViewSection.reviewView.updateOwnerParticipantCount(memberWalking.ownerReviewCount)
                    self.myPageView.contentViewSection.reviewView.updateChartData(scores: radarScores)
                    let averageScore = radarScores.reduce(0, +) / CGFloat(radarScores.count)
                    self.myPageView.contentViewSection.reviewView.updateStarRating(averageScore: averageScore)
                    self.myPageView.contentViewSection.reviewView.configureKeywords(
                        name: memberWalking.name,
                        tags: memberWalking.tags
                    )
                    self.myPageView.contentViewSection.reviewView.updateOwnerReviewSection(goodPercent: CGFloat(memberWalking.goodPercent) / 100, participantCount: memberWalking.ownerReviewCount)
                }
            } catch {
                print("Error fetching user profile: \(error)")
            }
        }
    }
    
    @objc private func navigateToOwnerReviewVC() {
        let nextVC = MyPageOwnerReviewViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension MatchingStatusApplicantDetailViewController: MyPageReviewViewDelegate {
    func walkerReviewTitleTapped() {
        navigateToOwnerReviewVC()
    }
}

