//
//  MatchingStatusApplicantListViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusApplicantListViewController: UIViewController {
    
    // MARK: - Properties
    private let applicantListView = MatchingStatusApplicantListView()
    private var matchingData: MatchingData?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        loadData()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(applicantListView)
        applicantListView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "지원한 산책자 보기",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
    }
    
    // MARK: - Data Management
    private func loadData() {
        matchingData = MatchingData(
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
        
        if let data = matchingData {
            applicantListView.configureContent(with: data)
        }
    }
}
