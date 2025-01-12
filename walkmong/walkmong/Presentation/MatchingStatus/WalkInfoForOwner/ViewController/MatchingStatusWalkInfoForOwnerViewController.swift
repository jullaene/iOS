//
//  MatchingStatusWalkInfoForOwnerViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusWalkInfoForOwnerViewController: UIViewController {
    
    // MARK: - Properties
    private let matchingStatusWalkInfoForOwnerView = MatchingStatusWalkInfoForOwnerView()
    private var matchingData: BoardList?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        loadData()
    }
    
    private func setupView() {
        view.backgroundColor = .gray100
        view.addSubview(matchingStatusWalkInfoForOwnerView)
        matchingStatusWalkInfoForOwnerView.snp.makeConstraints { make in
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
            startTime: "2025-01-03T00:32:40",
            endTime: "2025-01-03T14:32:30",
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
            createdAt: "2025-01-02T00:32:40"
        )
        matchingStatusWalkInfoForOwnerView.updateDogProfile(with: dogProfileData)
        
        let applicant = MatchingStatusApplicantInfo(
            ownerProfile: "https://img.freepik.com/free-photo/expressive-asian-girl-posing-indoor_344912-1234.jpg?semt=ais_hybrid",
            ownerName: "홍길동",
            ownerAge: 32,
            ownerGender: "MALE",
            dongAddress: "서울시 강남구",
            distance: 500
        )
        matchingStatusWalkInfoForOwnerView.configureApplicantsList(with: applicant)
    }
    
}
