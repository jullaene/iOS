//
//  CustomNavigationBar.swift
//  walkmong
//
//  Created by 황채웅 on 11/15/24.
//

import UIKit

@objc protocol CustomNavigationBarDelegate: AnyObject {
    @objc optional func didTapBackButton()
    @objc optional func didTapCloseButton()
    @objc optional func didTapRefreshButton()
}

class CustomNavigationBar: UIView {
    
    weak var delegate: CustomNavigationBarDelegate?
    
    private let backButtonButton = UIButton()
    private let closeButtonButton = UIButton()
    private let refreshButtonButton = UIButton()
    
    init(titleText: String, showLeftBackButton: Bool, showLeftCloseButton: Bool, showRightCloseButton: Bool, showRightRefreshButton: Bool) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        setupTitleLabel(titleText: titleText)
        setupLeftButtons(showLeftBackButton: showLeftBackButton, showLeftCloseButton: showLeftCloseButton)
        setupRightButtons(showRightCloseButton: showRightCloseButton, showRightRefreshButton: showRightRefreshButton)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.top.equalToSuperview().offset(52)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel(titleText: String) {
        let titleLabel = UpperTitleLabel(text: titleText, textColor: .mainBlack)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupLeftButtons(showLeftBackButton: Bool, showLeftCloseButton: Bool) {
        if showLeftBackButton {
            backButtonButton.setImage(.backButton, for: .normal)
            backButtonButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            self.addSubview(backButtonButton)
            backButtonButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
                make.leading.equalToSuperview().offset(20)
            }
        } else if showLeftCloseButton {
            closeButtonButton.setImage(.deleteButton, for: .normal)
            closeButtonButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            self.addSubview(closeButtonButton)
            closeButtonButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.leading.equalToSuperview().offset(20)
            }
        }
    }
    
    private func setupRightButtons(showRightCloseButton: Bool, showRightRefreshButton: Bool) {
        if showRightCloseButton {
            closeButtonButton.setImage(.deleteButton, for: .normal)
            closeButtonButton.tintColor = .mainBlack
            closeButtonButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            self.addSubview(closeButtonButton)
            closeButtonButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.trailing.equalToSuperview().offset(-20)
            }
        } else if showRightRefreshButton {
            refreshButtonButton.setImage(.refreshButton, for: .normal)
            refreshButtonButton.tintColor = .mainBlue
            refreshButtonButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
            self.addSubview(refreshButtonButton)
            refreshButtonButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
                make.trailing.equalToSuperview().offset(-20)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        delegate?.didTapBackButton?()
    }
    
    @objc private func closeButtonTapped() {
        delegate?.didTapCloseButton?()
    }
    
    @objc private func refreshButtonTapped() {
        delegate?.didTapRefreshButton?()
    }
}
