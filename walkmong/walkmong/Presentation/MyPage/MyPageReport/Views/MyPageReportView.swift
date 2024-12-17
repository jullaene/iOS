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
    private let titleLabel = MiddleTitleLabel(text: "신고 사유를 선택해주세요.", textColor: .gray600)
    private var navigationBar: UIView?
    private weak var viewController: UIViewController?
    
    // 리스트 항목
    private let reasons = [
        "산책과 관련 없는 내용",
        "음란성, 욕설 등 부적절한 내용",
        "부적절한 홍보 또는 광고",
        "산책과 관련없는 사진 게시",
        "개인정보 유출 위험",
        "산책 후기 작성 취지에 맞지 않는 내용(복사글 등)",
        "저작권 도용 의심(사진 등)",
        "기타(하단 내용 작성)"
    ]
    
    private var reasonButtons: [ReasonButtonView] = []
    
    // MARK: - Initializer
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        
        setupNavigationBar()
        setupLayout()
        setupReasonList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout 설정
    private func setupLayout() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        if let navigationBar = navigationBar {
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(navigationBar.snp.bottom).offset(43)
                make.left.equalToSuperview().offset(21)
            }
        }
    }
    
    // MARK: - NavigationBar 설정
    private func setupNavigationBar() {
        guard let viewController = viewController else { return }
        viewController.addCustomNavigationBar(
            titleText: "산책 후기 신고하기",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: true,
            showRightRefreshButton: false
        )
        
        if let navigationView = viewController.view.subviews.last {
            navigationBar = navigationView
            addSubview(navigationBar!)
            navigationBar?.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(safeAreaLayoutGuide.snp.top)
                make.height.equalTo(52)
            }
        }
    }
    
    // MARK: - 신고 사유 리스트 설정
    private func setupReasonList() {
        var previousView: UIView = titleLabel
        var isFirst = true // 첫 번째 뷰 여부를 체크하기 위한 플래그

        for reason in reasons {
            let reasonButton = ReasonButtonView(text: reason)
            addSubview(reasonButton)
            
            reasonButton.snp.makeConstraints { make in
                if isFirst {
                    make.top.equalTo(previousView.snp.bottom).offset(32) // 첫 번째만 32 포인트
                    isFirst = false
                } else {
                    make.top.equalTo(previousView.snp.bottom).offset(16) // 나머지는 16 포인트
                }
                make.leading.trailing.equalToSuperview().inset(21)
                make.height.equalTo(22)
            }
            
            previousView = reasonButton
            reasonButtons.append(reasonButton)
        }
    }
}
