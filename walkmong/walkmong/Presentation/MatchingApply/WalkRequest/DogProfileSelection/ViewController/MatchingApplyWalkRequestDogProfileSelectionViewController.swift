//
//  MatchingApplyWalkRequestDogProfileSelectionViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestDogProfileSelectionViewController: UIViewController {

    private let containerView = MatchingApplyWalkRequestView()
    private let dogProfileSelectionView = MatchingApplyWalkRequestDogProfileSelectionView()

    private var isDogSelected: Bool = false {
        didSet {
            containerView.actionButton.isEnabled = isDogSelected
            containerView.actionButton.setStyle(isDogSelected ? .dark : .light, type: .large)
        }
    }

    override func loadView() {
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addProgressBar(currentStep: 1, totalSteps: 5)
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
        view.backgroundColor = .white
        addCustomNavigationBar(
            titleText: "산책 지원 요청",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false
        )
        
        containerView.middleTitleLabel.text = "산책이 필요한 반려견을 선택해요."
        containerView.actionButton.setTitle("다음으로", for: .normal)
        containerView.updateContentView(with: dogProfileSelectionView)
    }

    private func setupActions() {
        containerView.actionButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        dogProfileSelectionView.onDogSelected = { [weak self] isSelected in
            self?.isDogSelected = isSelected
        }
    }

    @objc private func handleNextButtonTapped() {
        let nextVC = MatchingApplyWalkRequestInformationInputViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
