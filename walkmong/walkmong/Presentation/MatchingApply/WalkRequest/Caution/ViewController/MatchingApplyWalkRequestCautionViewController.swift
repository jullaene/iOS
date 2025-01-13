//
//  MatchingApplyWalkRequestCautionViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestCautionViewController: UIViewController {

    private let containerView = MatchingApplyWalkRequestView()
    private let cautionView = MatchingApplyWalkRequestCautionView()

    override func loadView() {
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addProgressBar(currentStep: 5, totalSteps: 5)
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
        
        containerView.middleTitleLabel.text = "주의사항 확인"
        containerView.actionButton.setTitle("산책 지원하기", for: .normal)
        containerView.updateContentView(with: cautionView)
        containerView.actionButton.addTarget(self, action: #selector(handleSubmitButtonTapped), for: .touchUpInside)
        containerView.showWarningSection()
    }

    @objc private func handleSubmitButtonTapped() {
        print("산책 지원 요청 완료")
        navigationController?.popToRootViewController(animated: true)
    }
}
