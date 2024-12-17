//
//  MyPageReportView.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

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

    // MARK: - Initializer
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        
        setupNavigationBar()
        setupLayout()
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
}
