//
//  CustomAlertView.swift
//  walkmong
//
//  Created by 황채웅 on 12/27/24.
//

import UIKit

public enum AlertTitleState {
    case useTitleOnly
    case useTitleAndSubTitle
}

public enum AlertButtonState {
    case singleButton
    case doubleButton
}


final class CustomAlertView: UIView {
    
    private var customTitleState: AlertTitleState?
    private var customButtonState: AlertButtonState?
    
    private var singleButtonAction: (() -> Void)?
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    private let frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel = MainParagraphLabel(text: "알림 메시지", textColor: UIColor(hexCode: "#444444"))
    
    private lazy var subTitleLabel = SmallMainParagraphLabel(text: "알림 메시지", textColor: .gray500)
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexCode: "#242424"), for: .normal)
        button.backgroundColor = .gray200
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray600
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var singleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray600
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(customTitleState: AlertTitleState,
                     customButtonState: AlertButtonState,
                     titleText: String,
                     subTitleText: String? = nil,
                     leftButtonTitle: String? = nil,
                     rightButtonTitle: String? = nil,
                     singleButtonTitle: String? = nil,
                     leftButtonAction: (() -> Void)? = nil,
                     rightButtonAction: (() -> Void)? = nil,
                     singleButtonAction: (() -> Void)? = nil) {
        self.init()
        self.customTitleState = customTitleState
        self.customButtonState = customButtonState
        addSubview()
        setConstraints()
        setTitleText(titleText: titleText, subTitleText: subTitleText)
        setButtonTitleText(leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle, singleButtonTitle: singleButtonTitle)
        self.setButtonAction(leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, singleButtonAction: singleButtonAction)
    }
    
    private func addSubview() {
        addSubview(frameView)
        
        frameView.addSubview(titleLabel)
        if customTitleState == .useTitleAndSubTitle {
            frameView.addSubviews(titleLabel, subTitleLabel)
        }
        
        if customButtonState == .singleButton {
            frameView.addSubview(singleButton)
        }else {
            frameView.addSubview(leftButton)
            frameView.addSubview(rightButton)
        }
    }
    
    private func setConstraints() {
        
        frameView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        if customTitleState == .useTitleAndSubTitle {
            subTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
            }
        }
        
        if customButtonState == .doubleButton {
            leftButton.snp.makeConstraints { make in
                if customTitleState == .useTitleAndSubTitle {
                    subTitleLabel.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalTo(titleLabel.snp.bottom).offset(4)
                    }
                }else {
                    make.top.equalToSuperview().offset(15)
                }
                make.leading.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().offset(-12)
                make.height.equalTo(44)
                make.width.equalTo(115)
            }
            rightButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-12)
                make.height.equalTo(44)
                make.width.equalTo(115)
            }
        }else {
            singleButton.snp.makeConstraints { make in
                if customTitleState == .useTitleAndSubTitle {
                    subTitleLabel.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalTo(titleLabel.snp.bottom).offset(4)
                    }
                }else {
                    make.top.equalToSuperview().offset(15)
                }
                make.height.equalTo(44)
                make.bottom.equalToSuperview().offset(-12)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
        }
        
    }
    
    private func setTitleText(titleText: String, subTitleText: String? = nil) {
        titleLabel.text = titleText
        if customTitleState == .useTitleAndSubTitle {
            subTitleLabel.text = subTitleText
            subTitleLabel.numberOfLines = 0
        }
    }
    
    private func setButtonTitleText(leftButtonTitle: String? = nil, rightButtonTitle: String? = nil, singleButtonTitle: String? = nil) {
        if customButtonState == .singleButton {
            singleButton.setTitle(singleButtonTitle, for: .normal)
        }else {
            leftButton.setTitle(leftButtonTitle, for: .normal)
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    private func setButtonAction(leftButtonAction: (() -> Void)? = nil, rightButtonAction: (() -> Void)? = nil, singleButtonAction: (() -> Void)? = nil) {
        if customButtonState == .singleButton {
            singleButton.addTarget(self, action: #selector(singleButtonTapped), for: .touchUpInside)
            self.singleButtonAction = singleButtonAction
        } else {
            leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
            self.leftButtonAction = leftButtonAction
            self.rightButtonAction = rightButtonAction
        }
    }
    
    @objc private func singleButtonTapped() {
        singleButtonAction?()
    }
    
    @objc private func leftButtonTapped() {
        leftButtonAction?()
    }
    
    @objc private func rightButtonTapped() {
        rightButtonAction?()
    }
    
    public func showCustomAlertView(on viewController: UIViewController) {
        guard let windowScene = viewController.view.window?.windowScene else { return }
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        self.frame = window.bounds
        window.addSubview(self)

        self.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
}
