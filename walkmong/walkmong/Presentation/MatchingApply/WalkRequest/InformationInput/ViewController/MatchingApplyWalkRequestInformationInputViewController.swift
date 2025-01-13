//
//  MatchingApplyWalkRequestInformationInputViewController.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit

protocol MatchingApplyWalkRequestInformationInputViewDelegate: AnyObject {
    func updateActionButtonState(isEnabled: Bool)
    func updateTimeSelection(startTime: String, endTime: String)
}

final class MatchingApplyWalkRequestInformationInputViewController: UIViewController {
    var startTime: String = ""
    var endTime: String = ""
    private var inputTexts: [String] = ["", "", ""]
    private var selectionTexts: [String] = []
    var receivedTexts: [String] = []

    private let containerView = MatchingApplyWalkRequestView()
    private let informationInputView = MatchingApplyWalkRequestInformationInputView()

    private var allFieldsFilled: Bool = false {
        didSet {
            containerView.actionButton.isEnabled = allFieldsFilled
            containerView.actionButton.setStyle(allFieldsFilled ? .dark : .light, type: .large)
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
        addProgressBar(currentStep: 2, totalSteps: 5)
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
        
        containerView.middleTitleLabel.text = "산책 정보 작성하기"
        containerView.actionButton.setTitle("다음으로", for: .normal)
        containerView.updateContentView(with: informationInputView)
    }

    private func setupActions() {
        containerView.actionButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        informationInputView.delegate = self
    }

    @objc private func handleNextButtonTapped() {
        
        let nextVC = MatchingApplyWalkRequestTextInputViewController()

        nextVC.receivedTexts = inputTexts
        nextVC.startTime = startTime
        nextVC.endTime = endTime

        let selection1Text = informationInputView.getSelectedText(from: informationInputView.selectionView1)
        let selection3Text = informationInputView.getSelectedText(from: informationInputView.selectionView3)
        nextVC.selectionTexts = [selection1Text, selection3Text]

        navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension MatchingApplyWalkRequestInformationInputViewController: MatchingApplyWalkRequestInformationInputViewDelegate {
    func updateActionButtonState(isEnabled: Bool) {
        allFieldsFilled = isEnabled
    }

    func updateTimeSelection(startTime: String, endTime: String) {
        self.startTime = startTime
        self.endTime = endTime
    }
}
