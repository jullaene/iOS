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
        navigationBarView.backgroundColor = .white
        self.view.addSubview(navigationBarView)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(76)
        }
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = titleText
            label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
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
                button.setImage(.backButton, for: .normal)
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
        } else if showRefreshBarButton {
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
    }
    
    func addProgressBar(currentStep:Int, totalSteps:Int){
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        let progressBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray200
            view.layer.cornerRadius = 2
            return view
        }()
        let progressView: UIView = {
            let view = UIView()
            view.backgroundColor = .mainBlue
            view.layer.cornerRadius = 2
            return view
        }()
        
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(progressBackgroundView)
        backgroundView.addSubview(progressView)
        
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(119)
            make.height.equalTo(35)
        }
        progressBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(7)
            make.height.equalTo(4)
        }
        progressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(7)
            make.width.equalTo((view.bounds.width-40)*CGFloat(currentStep)/CGFloat(totalSteps))
            make.height.equalTo(4)
        }
    }
}
