//
//  CustomAlertViewController.swift
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

final class CustomAlertViewController: UIViewController {
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
    
    private let titleLabel = MainHighlightParagraphLabel(text: "알림 메시지", textColor: UIColor(hexCode: "#444444"))
    
    private lazy var subTitleLabel = SmallMainParagraphLabel(text: "알림 메시지", textColor: .gray500)
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexCode: "#242424"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.backgroundColor = .gray200
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.backgroundColor = .gray600
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var singleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.backgroundColor = .gray600
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    init(titleState: AlertTitleState, buttonState: AlertButtonState) {
        self.customTitleState = titleState
        self.customButtonState = buttonState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(frameView)
        
        frameView.addSubview(titleStack)
        titleStack.addArrangedSubview(titleLabel)
        
        if customTitleState == .useTitleAndSubTitle {
            titleStack.addArrangedSubview(subTitleLabel)
        }
        
        switch customButtonState {
        case .singleButton:
            buttonStack.addArrangedSubview(singleButton)
        case .doubleButton:
            buttonStack.addArrangedSubview(leftButton)
            buttonStack.addArrangedSubview(rightButton)
        default:
            break
        }
        frameView.addSubview(buttonStack)
    }
    
    private func setConstraints() {
        frameView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
        }
        
        titleStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleStack.snp.bottom).offset(27)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        
    }
    
    
    public func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    class CustomAlertBuilder {
        
        private let baseViewController: UIViewController
        
        init(viewController: UIViewController) {
            baseViewController = viewController
        }
        
        private var titleState: AlertTitleState = .useTitleOnly
        private var buttonState: AlertButtonState = .singleButton
        private var titleText: String = ""
        private var subTitleText: String? = nil
        private var leftButtonTitle: String? = nil
        private var rightButtonTitle: String? = nil
        private var singleButtonTitle: String? = nil
        private var leftButtonAction: (() -> Void)? = nil
        private var rightButtonAction: (() -> Void)? = nil
        private var singleButtonAction: (() -> Void)? = nil
        
        func setTitleState(_ state: AlertTitleState) -> CustomAlertBuilder {
            self.titleState = state
            return self
        }
        
        func setButtonState(_ state: AlertButtonState) -> CustomAlertBuilder {
            self.buttonState = state
            return self
        }
        
        func setTitleText(_ text: String) -> CustomAlertBuilder {
            self.titleText = text
            return self
        }
        
        func setSubTitleText(_ text: String?) -> CustomAlertBuilder {
            self.subTitleText = text
            return self
        }
        
        func setLeftButtonTitle(_ title: String?) -> CustomAlertBuilder {
            self.leftButtonTitle = title
            return self
        }
        
        func setRightButtonTitle(_ title: String?) -> CustomAlertBuilder {
            self.rightButtonTitle = title
            return self
        }
        
        func setSingleButtonTitle(_ title: String?) -> CustomAlertBuilder {
            self.singleButtonTitle = title
            return self
        }
        
        func setLeftButtonAction(_ action: (() -> Void)?) -> CustomAlertBuilder {
            self.leftButtonAction = action
            return self
        }
        
        func setRightButtonAction(_ action: (() -> Void)?) -> CustomAlertBuilder {
            self.rightButtonAction = action
            return self
        }
        
        func setSingleButtonAction(_ action: (() -> Void)?) -> CustomAlertBuilder {
            self.singleButtonAction = action
            return self
        }
        
        func buildAlertView() -> CustomAlertViewController {
            let viewController = CustomAlertViewController(titleState: self.titleState, buttonState: self.buttonState)
            
            viewController.titleLabel.text = self.titleText
            viewController.subTitleLabel.text = self.subTitleText
            
            viewController.leftButton.setTitle(self.leftButtonTitle, for: .normal)
            viewController.rightButton.setTitle(self.rightButtonTitle, for: .normal)
            viewController.singleButton.setTitle(self.singleButtonTitle, for: .normal)
            
            viewController.leftButtonAction = self.leftButtonAction
            viewController.rightButtonAction = self.rightButtonAction
            viewController.singleButtonAction = self.singleButtonAction
            
            return viewController
        }
        
        func showAlertView() {
            let viewController = buildAlertView()
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            viewController.setupView()
            viewController.setConstraints()
            baseViewController.present(viewController, animated: true)
        }
    }
}
