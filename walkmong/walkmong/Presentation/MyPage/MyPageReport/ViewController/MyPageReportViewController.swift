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
        setupSubmitButtonAction()
        setupReasonButtonActions()
        configureTextView()
        checkSubmitButtonState()
    }
    
    private func setupSubmitButtonAction() {
        myPageReportView.submitButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    private func setupReasonButtonActions() {
        for button in myPageReportView.reasonButtons {
            button.onCheckStateChanged = { [weak self] in
                self?.checkSubmitButtonState()
            }
        }
    }
    
    private func configureTextView() {
        myPageReportView.reportTextView.didChangeText = { [weak self] count in
            self?.autoCheckOtherReasonIfNeeded()
            self?.checkSubmitButtonState()
        }
    }
    
    private func autoCheckOtherReasonIfNeeded() {
        let otherReasonIndex = myPageReportView.reasons.count - 1
        let otherReasonButton = myPageReportView.reasonButtons[otherReasonIndex]
        
        let textView = myPageReportView.reportTextView
        let hasContent = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
                         textView.text != textView.placeholderText
        
        if hasContent && !otherReasonButton.isChecked {
            otherReasonButton.isChecked = true
            otherReasonButton.updateCheckImage()
        } else if !hasContent && otherReasonButton.isChecked {
            otherReasonButton.isChecked = false
            otherReasonButton.updateCheckImage()
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
        setupSubmitButtonAction()
    }
    
    private func setupNavigationBar() {
        addCustomNavigationBar(
            titleText: "산책 후기 신고하기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: true,
            showRightRefreshButton: false
        )
        let closeBarButtonItem = UIBarButtonItem(
            image: .deleteButton,
            style: .plain,
            target: self,
            action: #selector(dismissViewController)
        )
        closeBarButtonItem.tintColor = .mainBlack
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
    }
    
    @objc private func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
}
