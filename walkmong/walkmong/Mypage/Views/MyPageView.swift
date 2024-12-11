//
//  MyPageView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    
    private let navigationBar: CustomNavigationBar = {
        let bar = CustomNavigationBar(
            titleText: "마이페이지",
            showLeftBackButton: false,
            showLeftCloseButton: false,
            showRightCloseButton: false,
            showRightRefreshButton: false,
            backgroundColor: .clear
        )
        return bar
    }()
    
    private let profileView = MyPageProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainBlue
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(navigationBar)
        addSubview(profileView)
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.height.equalTo(75)
        }
    }
}
