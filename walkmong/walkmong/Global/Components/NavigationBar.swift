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
        
        let titleLabel = UpperTitleLabel(text: titleText ?? "")
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        navigationBarView.addSubview(titleLabel)
        
        if showLeftBackButton {
            let backButton: UIButton = {
                let button = UIButton()
                button.setImage(.backButton, for: .normal)
                button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
                return button
            }()
            navigationBarView.addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(28)
                make.leading.equalToSuperview().offset(16)
            }
        }  else if showLeftCloseButton {
            let closeBarButton: UIButton = {
                let button = UIButton()
                button.setImage(.deleteButton, for: .normal)
                return button
            }()
            navigationBarView.addSubview(closeBarButton)
            closeBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.leading.equalToSuperview().offset(16)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        if showRightCloseButton {
            let closeBarButton: UIButton = {
                let button = UIButton()
                button.setImage(.deleteButton, for: .normal)
                button.tintColor = .mainBlack
                button.addTarget(self, action: #selector(handleCloseButtonTapped), for: .touchUpInside)
                return button
            }()
            navigationBarView.addSubview(closeBarButton)
            closeBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(24)
                make.trailing.equalToSuperview().offset(-16)
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
                make.trailing.equalToSuperview().offset(-16)
            }
        }
        
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    // MARK: - Button Handlers with Effects
    @objc private func handleBackButtonTapped() {
        triggerCustomTransition(type: .push, direction: .fromLeft)
        popViewController()
    }
    
    @objc private func handleCloseButtonTapped() {
        triggerCustomTransition(type: .fade, direction: nil)
        popViewController()
    }
    
    @objc private func handleRefreshButtonTapped() {
        print("Refresh button tapped")
    }
    
    @objc private func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Custom Transition Effects
    private func triggerCustomTransition(type: CATransitionType, direction: CATransitionSubtype?) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = type
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}
