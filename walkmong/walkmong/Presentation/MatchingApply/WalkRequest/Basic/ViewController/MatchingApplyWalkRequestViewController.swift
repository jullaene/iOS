//
//  MatchingApplyWalkRequestViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit

protocol StepConfigurable {
    var stepTitle: String { get }
    var buttonTitle: String { get }
    var isButtonEnabled: Bool { get }
    var isWarningVisible: Bool { get }
    var buttonStateChanged: ((Bool) -> Void)? { get set }
}

final class MatchingApplyWalkRequestViewController: UIViewController {

    private let walkRequestView = MatchingApplyWalkRequestView()
    private var currentStep: Int = 1
    private let totalSteps: Int = 5

    private let stepControllers: [UIViewController & StepConfigurable] = [
        MatchingApplyWalkRequestDogProfileSelectionViewController(),
        MatchingApplyWalkRequestInformationInputViewController(),
        MatchingApplyWalkRequestTextInputViewController(),
        MatchingApplyWalkRequestViewSummarizeViewController(),
        MatchingApplyWalkRequestCautionViewController()
    ]

    override func loadView() {
        self.view = walkRequestView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateViewForCurrentStep()
    }

    private func setupUI() {
        view.backgroundColor = .white
        addCustomNavigationBar(
            titleText: "산책 지원 요청하기",
            showLeftBackButton: true,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        addProgressBar(currentStep: currentStep, totalSteps: totalSteps)
    }

    private func setupActions() {
        walkRequestView.actionButton.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
    }

    @objc private func handleActionButtonTapped() {
        guard currentStep < totalSteps else {
            print("완료 처리")
            return
        }
        currentStep += 1
        updateViewForCurrentStep()
    }

    private func updateViewForCurrentStep() {
        var currentController = stepControllers[currentStep - 1]
        addChild(currentController)
        currentController.didMove(toParent: self)
        walkRequestView.updateContentView(with: currentController.view)
        addProgressBar(currentStep: currentStep, totalSteps: totalSteps)

        walkRequestView.middleTitleLabel.text = currentController.stepTitle
        walkRequestView.actionButton.setTitle(currentController.buttonTitle, for: .normal)
        updateActionButtonState(isEnabled: currentController.isButtonEnabled)

        if currentController.isWarningVisible {
            walkRequestView.showWarningSection()
        } else {
            walkRequestView.hideWarningSection()
        }
        
        currentController.buttonStateChanged = { [weak self] isEnabled in
            self?.updateActionButtonState(isEnabled: isEnabled)
        }
    }

    private func updateActionButtonState(isEnabled: Bool) {
        walkRequestView.actionButton.isEnabled = isEnabled
        walkRequestView.actionButton.setStyle(isEnabled ? .dark : .light, type: .large)
    }
}
