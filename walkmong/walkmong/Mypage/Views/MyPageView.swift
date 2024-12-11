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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    private let contentViewSection = MyPageContentViewSection()
    private let settingsView = MyPageSettingsView()
    
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
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(profileView)
        contentView.addSubview(contentViewSection)
        contentView.addSubview(settingsView)
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(75)
        }
        
        contentViewSection.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        settingsView.snp.makeConstraints { make in
            make.top.equalTo(contentViewSection.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
