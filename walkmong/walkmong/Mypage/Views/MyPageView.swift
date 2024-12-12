//
//  MyPageView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    
    // MARK: - Properties
    private let safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
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
        scrollView.backgroundColor = .gray100
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
    let contentViewSection = MyPageContentViewSection()
    private let spacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    private let settingsView = MyPageSettingsView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        addSubview(safeAreaBackgroundView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let topBackgroundView = createTopBackgroundView()
        contentView.addSubview(topBackgroundView)
        
        contentView.addSubview(navigationBar)
        contentView.addSubview(profileView)
        contentView.addSubview(contentViewSection)
        contentView.addSubview(spacerView)
        contentView.addSubview(settingsView)
        
        topBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentViewSection.snp.top)
        }
    }
    
    private func setupConstraints() {
        safeAreaBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(settingsView.snp.bottom)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(75)
        }
        
        contentViewSection.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview()
        }
        
        spacerView.snp.makeConstraints { make in
            make.top.equalTo(contentViewSection.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
        
        settingsView.snp.makeConstraints { make in
            make.top.equalTo(spacerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helper Methods
    private func createTopBackgroundView() -> UIView {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .mainBlue
        return topBackgroundView
    }
}
