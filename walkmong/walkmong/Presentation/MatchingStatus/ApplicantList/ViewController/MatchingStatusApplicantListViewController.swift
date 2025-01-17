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
    private var matchingData: BoardList?
    private var applicants: [MatchingStatusApplicantDetail] = []

    // MARK: - Initializer
    init(matchingData: BoardList, applicants: [MatchingStatusApplicantDetail]) {
        self.matchingData = matchingData
        self.applicants = applicants
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        configureData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
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

    // MARK: - Configure Data
    private func configureData() {
        if let matchingData = matchingData {
            applicantListView.configureDogProfile(with: matchingData)
        }
        applicantListView.configureApplicantsList(with: applicants)
    }
}
