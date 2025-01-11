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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        resetCheckBoxAndButtonState()
        
        if currentController is MatchingApplyWalkRequestViewSummarizeViewController ||
           currentController is MatchingApplyWalkRequestCautionViewController {
            walkRequestView.backgroundColor = .gray100
        } else {
            walkRequestView.backgroundColor = .white
        }
        
        if currentController is MatchingApplyWalkRequestTextInputViewController {
            walkRequestView.updateWarningText("산책 지원 요청 내용을 확인했습니다.")
        } else {
            walkRequestView.updateWarningText("주의사항을 모두 확인했습니다.")
        }

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
    
    private func resetCheckBoxAndButtonState() {
        walkRequestView.checkBoxIcon.image = UIImage(named: "check-box-lined")
        walkRequestView.actionButton.isEnabled = false
        walkRequestView.actionButton.setStyle(.light, type: .large)
    }
}
