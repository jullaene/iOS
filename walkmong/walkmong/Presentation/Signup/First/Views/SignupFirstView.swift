//
//  SignupFirstView.swift
//  walkmong
//
//  Created by 황채웅 on 1/9/25.
//

import UIKit

protocol SignupFirstViewDelegate: AnyObject {
    func didTapEmailSignupButton()
    func didTapLoginButton()
}


final class SignupFirstView: UIView {
    
    private let logoTextView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logoTextView
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let illustrationView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .signupIllustration
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailSignupButton = NextButton(text: "이메일로 시작하기")
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("로그인하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitleColor(UIColor(hexCode: "#1C1B1F"), for: .normal)
        button.setTitleColor(UIColor(hexCode: "#1C1B1F"), for: .selected)
        return button
    }()
    
    weak var delegate: SignupFirstViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(logoTextView, illustrationView, emailSignupButton, loginButton)
    }
    
    private func setConstraints() {
        logoTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(136)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(80)
        }
        illustrationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
            make.top.equalTo(logoTextView.snp.bottom).offset(75)
        }
        emailSignupButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(loginButton.snp.top).offset(-23)
        }
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-65)
        }
    }
    
    private func setButtonAction() {
        emailSignupButton.setButtonState(isEnabled: true)
        emailSignupButton.addTarget(self, action: #selector(emailSignupButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func emailSignupButtonTapped() {
        delegate?.didTapEmailSignupButton()
    }
    
    @objc private func loginButtonTapped() {
        delegate?.didTapLoginButton()
    }
}
