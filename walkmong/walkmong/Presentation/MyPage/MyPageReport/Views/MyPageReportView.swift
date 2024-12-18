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
    private let navigationBar = UIView()
    private let titleLabel = MiddleTitleLabel(text: "산책 후기 신고하기", textColor: .black)
    let reportTextView = ReportTextView()
    let charCountLabel = MainParagraphLabel(text: "(0/250)", textColor: .gray400)
    let submitButton = UIButton.createStyledButton(type: .large, style: .dark, title: "신고하기")
    var reasonButtons: [ReasonButtonView] = []
    
    // 리스트 항목
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 설정
    private func setupView() {
        self.backgroundColor = .white
        setupNavigationBar()
        setupReasonList()
        setupReportTextView()
        setupSubmitButton()
    }
    
    private func setupNavigationBar() {
        addSubview(navigationBar)
        navigationBar.backgroundColor = .white
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(31)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    private func setupReasonList() {
        var previousView: UIView = titleLabel
        
        for (index, reason) in reasons.enumerated() {
            let reasonButton = ReasonButtonView(text: reason)
            reasonButtons.append(reasonButton)
            addSubview(reasonButton)
            
            reasonButton.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(index == 0 ? 32 : 16)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(22)
            }
            previousView = reasonButton
        }
    }
    
    private func setupReportTextView() {
        addSubview(reportTextView)
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonButtons.last!.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(169)
        }
        
        addSubview(charCountLabel)
        charCountLabel.textAlignment = .right
        charCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(reportTextView).offset(-12)
            make.trailing.equalTo(reportTextView).offset(-12)
        }
    }
    
    private func setupSubmitButton() {
        submitButton.removeSizeConstraints()
        addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(reportTextView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }
    }
}
