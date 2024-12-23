//
//  MyPageReportView.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

import UIKit
import SnapKit

class MyPageReportView: UIView {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navigationBar = UIView()
    private let titleLabel = MiddleTitleLabel(text: "산책 후기 신고하기", textColor: .black)
    let reportTextView = ReportTextView()
    let charCountLabel = MainParagraphLabel(text: "(0/250)", textColor: .gray400)
    let submitButton = UIButton.createStyledButton(type: .large, style: .dark, title: "신고하기")
    var reasonButtons: [ReasonButtonView] = []
    
    let reasons = [
        "산책과 관련 없는 내용",
        "음란성, 욕설 등 부적절한 내용",
        "부적절한 홍보 또는 광고",
        "산책과 관련없는 사진 게시",
        "개인정보 유출 위험",
        "산책 후기 작성 취지에 맞지 않는 내용(복사글 등)",
        "저작권 도용 의심(사진 등)",
        "기타(하단 내용 작성)"
    ]
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setupView()
        setupKeyboardNotifications()
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 설정
    private func setupView() {
        setupBaseLayout()
        setupNavigationBar()
        setupScrollView()
        setupContentLayout()
    }
    
    private func setupBaseLayout() {
        self.backgroundColor = .white
        addSubview(navigationBar)
        addSubview(scrollView)
    }
    
    private func setupNavigationBar() {
        navigationBar.backgroundColor = .white
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupContentLayout() {
        setupTitleLabel()
        setupReasonButtons()
        setupReportSection()
        setupSubmitButton()
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(31)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupReasonButtons() {
        var previousView: UIView = titleLabel
        
        reasons.enumerated().forEach { index, reason in
            let reasonButton = ReasonButtonView(text: reason)
            reasonButtons.append(reasonButton)
            contentView.addSubview(reasonButton)
            reasonButton.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(index == 0 ? 32 : 16)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(22)
            }
            previousView = reasonButton
        }
    }
    
    private func setupReportSection() {
        contentView.addSubview(reportTextView)
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonButtons.last!.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(169)
        }
        
        contentView.addSubview(charCountLabel)
        charCountLabel.textAlignment = .right
        charCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(reportTextView).offset(-12)
            make.trailing.equalTo(reportTextView).offset(-12)
        }
    }
    
    private func setupSubmitButton() {
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(reportTextView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - 키보드 알림 설정
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 키보드 동작
    @objc private func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification, isShowing: true)
        scrollToBottom()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification, isShowing: false)
    }
    
    private func adjustForKeyboard(notification: NSNotification, isShowing: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = isShowing
            ? UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            : UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}

extension UIResponder {
    private static weak var currentResponder: UIResponder?
    
    static func currentFirstResponder() -> UIResponder? {
        currentResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        return currentResponder
    }
    
    @objc private func findFirstResponder() {
        UIResponder.currentResponder = self
    }
}
