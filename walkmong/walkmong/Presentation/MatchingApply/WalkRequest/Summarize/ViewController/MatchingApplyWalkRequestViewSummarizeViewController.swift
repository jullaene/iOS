//
//  MatchingApplyWalkRequestViewSummarizeViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestViewSummarizeViewController: UIViewController {

    private let containerView = MatchingApplyWalkRequestView()
    private let summarizeView = MatchingApplyWalkRequestViewSummarizeView()

    override func loadView() {
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addProgressBar(currentStep: 4, totalSteps: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setupUI() {
        view.backgroundColor = .gray100

        addCustomNavigationBar(
            titleText: "산책 지원 요청",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        
        containerView.middleTitleLabel.text = "산책 요청 최종 확인"
        containerView.actionButton.setTitle("다음으로", for: .normal)
        containerView.updateContentView(with: summarizeView)
        containerView.actionButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        containerView.updateWarningText("산책 지원 요청 내용을 확인했습니다.")
        containerView.showWarningSection()
    }

    @objc private func handleNextButtonTapped() {
        let nextVC = MatchingApplyWalkRequestCautionViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
