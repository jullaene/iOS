//
//  NavigationBar.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

extension UIViewController {
    // MARK: - Custom Navigation Bar
    func addCustomNavigationBar(titleText: String = "", showLeftBarButton: Bool, showCloseBarButton: Bool, showRefreshBarButton: Bool) {
        
        let navigationBarView = UIView()
        navigationBarView.backgroundColor = .gray100
        self.view.addSubview(navigationBarView)
        self.navigationItem.titleView = navigationBarView
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(76)
        }
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = titleText
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .mainBlack
            label.textAlignment = .center
            return label
        }()
        
        navigationBarView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Left bar button 설정
        if showLeftBarButton {
            let leftBarButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                button.tintColor = .mainBlack
                return button
            }()
            navigationBarView.addSubview(leftBarButton)
            leftBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.leading.equalToSuperview().offset(20)
            }
        }

        // Close bar button 설정
        if showCloseBarButton {
            let closeBarButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(systemName: "xmark"), for: .normal)
                button.tintColor = .mainBlack
                return button
            }()
            navigationBarView.addSubview(closeBarButton)
            closeBarButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.trailing.equalToSuperview().offset(-20)
            }
        } else if showRefreshBarButton {
            let refreshBarButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
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
    }
}
