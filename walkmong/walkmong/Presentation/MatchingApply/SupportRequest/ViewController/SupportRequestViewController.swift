//
//  SupportRequestViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit

struct StepData {
    let middleTitle: String
    let buttonText: String
    let additionalView: UIView
    let backgroundColor: UIColor
}

final class SupportRequestViewController: UIViewController {

    private let supportRequestView = SupportRequestView()
    private var currentStep: Int = 1
    private let totalSteps: Int = 4

    private let stepData: [StepData] = [
        StepData(
            middleTitle: "산책이 필요한 반려견을 선택해요.",
            buttonText: "다음으로",
            additionalView: SupportRequestView1(),
            backgroundColor: .white
        ),
        StepData(
            middleTitle: "산책 정보 작성하기",
            buttonText: "다음으로",
            additionalView: SupportRequestView2(),
            backgroundColor: .white
        ),
        StepData(
            middleTitle: "산책 요청 최종 확인",
            buttonText: "다음으로",
            additionalView: SupportRequestView3(),
            backgroundColor: .gray100
        ),
        StepData(
            middleTitle: "주의사항 확인",
            buttonText: "산책 지원하기",
            additionalView: SupportRequestView4(),
            backgroundColor: .gray100
        )
    ]

    override func loadView() {
        super.loadView()
        self.view = supportRequestView
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
        supportRequestView.actionButton.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
    }

    @objc private func handleActionButtonTapped() {
        if currentStep < totalSteps {
            currentStep += 1
            updateViewForCurrentStep()
        } else {
            print("완료 처리")
        }
    }

    private func updateViewForCurrentStep() {
        guard currentStep <= totalSteps else { return }
        let data = stepData[currentStep - 1]

        view.backgroundColor = data.backgroundColor

        supportRequestView.middleTitleLabel.text = data.middleTitle
        supportRequestView.actionButton.setTitle(data.buttonText, for: .normal)

        supportRequestView.contentView.subviews.forEach {
            if $0 != supportRequestView.middleTitleLabel {
                $0.removeFromSuperview()
            }
        }

        let additionalView = data.additionalView
        supportRequestView.contentView.addSubview(additionalView)

        additionalView.snp.makeConstraints { make in
            make.top.equalTo(supportRequestView.middleTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }

        addProgressBar(currentStep: currentStep, totalSteps: totalSteps)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
}
