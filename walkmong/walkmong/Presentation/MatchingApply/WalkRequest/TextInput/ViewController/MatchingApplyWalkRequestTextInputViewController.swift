//
//  MatchingApplyWalkRequestTextInputViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

final class MatchingApplyWalkRequestTextInputViewController: UIViewController {
    var receivedTexts: [String] = []
    var startTime: String = ""
    var endTime: String = ""
    var inputTexts: [String] = ["", "", ""]
    var selectionTexts: [String] = []
    var selectedDogId: Int?
    
    private let containerView = MatchingApplyWalkRequestView()
    private let textInputView = MatchingApplyWalkRequestTextInputView()

    private var allRequiredFieldsFilled: Bool = false {
        didSet {
            containerView.actionButton.isEnabled = allRequiredFieldsFilled
            containerView.actionButton.setStyle(allRequiredFieldsFilled ? .dark : .light, type: .large)
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
        addProgressBar(currentStep: 3, totalSteps: 5)
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
        
        containerView.middleTitleLabel.text = "산책자에게 전달할 메시지"
        containerView.actionButton.setTitle("다음으로", for: .normal)
        containerView.updateContentView(with: textInputView)
    }

    private func setupActions() {
        containerView.actionButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        textInputView.textViewDidUpdate = { [weak self] isAllFilled, updatedTexts in
            self?.allRequiredFieldsFilled = isAllFilled
            self?.inputTexts = updatedTexts
        }
    }

    @objc private func handleNextButtonTapped() {
        let nextVC = MatchingApplyWalkRequestViewSummarizeViewController()
        nextVC.receivedTexts = inputTexts
        nextVC.selectionTexts = selectionTexts
        nextVC.startTime = startTime
        nextVC.endTime = endTime
        nextVC.selectedDogId = selectedDogId // 전달 추가
        print("TextInputViewController에서 전달된 dogId: \(String(describing: selectedDogId))") // 디버그 로그
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
