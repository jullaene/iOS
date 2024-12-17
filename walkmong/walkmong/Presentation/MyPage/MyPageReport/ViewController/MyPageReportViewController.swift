//
//  MyPageReportViewController.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

class MyPageReportViewController: UIViewController {
    private lazy var myPageReportView = MyPageReportView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupReasonButtonActions()
        configureTextView()
        checkSubmitButtonState()
    }
    
    private func setupReasonButtonActions() {
        for button in myPageReportView.reasonButtons {
            button.onCheckStateChanged = { [weak self] in
                self?.checkSubmitButtonState()
            }
        }
    }
    
    private func configureTextView() {
        myPageReportView.reportTextView.didChangeText = { [weak self] _ in
            self?.checkSubmitButtonState()
        }
    }
    
    private func checkSubmitButtonState() {
        let isAnyReasonSelected = myPageReportView.reasonButtons.contains { $0.isChecked }
        
        let otherReasonIndex = myPageReportView.reasons.count - 1
        let isOtherReasonSelected = myPageReportView.reasonButtons[otherReasonIndex].isChecked
        
        let isOtherReasonValid = isOtherReasonSelected ? !myPageReportView.reportTextView.text.isEmpty &&
                                                        myPageReportView.reportTextView.text != myPageReportView.reportTextView.placeholderText : true
        
        let canSubmit = isAnyReasonSelected && isOtherReasonValid
        myPageReportView.submitButton.isEnabled = canSubmit
        
        let buttonStyle: UIButton.ButtonStyle = canSubmit ? .dark : .light
        myPageReportView.submitButton.updateStyle(type: .large, style: buttonStyle)
    }
    
    private func setupView() {
        view.addSubview(myPageReportView)
        myPageReportView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기 신고하기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: true,
            showRightRefreshButton: false
        )
        navigationItem.rightBarButtonItem?.action = #selector(dismissViewController)
        navigationItem.rightBarButtonItem?.target = self
    }
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
