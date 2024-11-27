//
//  NavigationBar.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit

extension UIViewController {
    // MARK: - Custom Navigation Bar
    func addCustomNavigationBar(titleText: String?, showLeftBackButton: Bool, showLeftCloseButton: Bool, showRightCloseButton: Bool, showRightRefreshButton: Bool, backgroundColor: UIColor = .white) {
        
        let navigationBarView = UIView()
        navigationBarView.backgroundColor = backgroundColor
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.addSubview(navigationBarView)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        let titleLabel = UpperTitleLabel(text: "")
        
        navigationBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Left button 설정
        if showLeftBackButton {
            let backButtonButton: UIButton = {
                let button = UIButton()
                button.setImage(.backButton, for: .normal)
                button.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside)
                return button
            }()
            navigationBarView.addSubview(backButtonButton)
            backButtonButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
                make.leading.equalToSuperview().offset(20)
            }
        } else if showLeftCloseButton {
            let closeBarButton: UIButton = {
                let button = UIButton()
                button.setImage(.deleteButton, for: .normal)
                return button
            }()
            navigationBarView.addSubview(closeBarButton)
            closeBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.leading.equalToSuperview().offset(20)
            }
        }

        // Right button 설정
        if showRightCloseButton {
            let closeBarButton: UIButton = {
                let button = UIButton()
                button.setImage(.deleteButton, for: .normal)
                button.tintColor = .mainBlack
                return button
            }()
            navigationBarView.addSubview(closeBarButton)
            closeBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.trailing.equalToSuperview().offset(-20)
            }
        } else if showRightRefreshButton {
            let refreshBarButton: UIButton = {
                let button = UIButton()
                button.setImage(.refreshButton, for: .normal)
                button.tintColor = .mainBlue
                return button
            }()
            navigationBarView.addSubview(refreshBarButton)
            refreshBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.trailing.equalToSuperview().offset(-20)
            }
        }

        // Enable Swipe Back Gesture
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }

    @objc private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
