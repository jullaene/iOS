//
//  LoginView.swift
//  walkmong
//
//  Created by 황채웅 on 1/9/25.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapLoginButton(email: String, password: String, keepLogin: Bool, keepEmail: String?) async
}

final class LoginView: UIView {
    
    private let emailTextField = TextField(placeHolderText: "이메일을 입력해주세요", keyboardType: .emailAddress, shouldHideText: false, textContentType: .emailAddress, useCustomDelegate: true)
    
    private let passwordTextField = TextField(placeHolderText: "비밀번호를 입력해주세요", keyboardType: .default, shouldHideText: true, textContentType: .password, useCustomDelegate: true)
    
    private let keepLoginButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 7
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .clear
        button.setTitle("로그인 유지", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setImage(.unchecked, for: .normal)
        button.setImage(.checked, for: .selected)
        button.setTitleColor(.gray400, for: .normal)
        button.setTitleColor(.gray400, for: .selected)
        return button
    }()
    
    private let keepEmailButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 7
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.tintColor = .clear
        button.setTitle("이메일 저장하기", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setImage(.unchecked, for: .normal)
        button.setImage(.checked, for: .selected)
        button.setTitleColor(.gray400, for: .normal)
        button.setTitleColor(.gray400, for: .selected)
        return button
    }()
    
    private let loginButton = NextButton(text: "로그인하기")
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(emailTextField, passwordTextField, keepEmailButton, keepLoginButton, loginButton)
    }
    
    private func setConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(46)
        }
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(emailTextField.snp.bottom).offset(17)
            make.height.equalTo(46)
        }
        keepLoginButton.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField.snp.leading)
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        keepEmailButton.snp.makeConstraints { make in
            make.leading.equalTo(keepLoginButton.snp.trailing).offset(18)
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(67)
            make.height.equalTo(50)
        }
    }
    
    private func setButtonActions() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        keepEmailButton.addTarget(self, action: #selector(keepEmailButtonTapped), for: .touchUpInside)
        keepLoginButton.addTarget(self, action: #selector(keepLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Task {
                await delegate?.didTapLoginButton(email: email, password: password, keepLogin: keepLoginButton.isSelected, keepEmail: keepEmailButton.isSelected ? emailTextField.text : nil)
            }
        }
    }
    
    @objc private func keepEmailButtonTapped() {
        keepEmailButton.isSelected.toggle()
    }
    
    @objc private func keepLoginButtonTapped() {
        keepLoginButton.isSelected.toggle()
    }
    
    func setSavedEmail(email: String) {
        emailTextField.text = email
    }
    
}

extension LoginView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet.whitespaces
        if string.rangeOfCharacter(from: invalidCharacters) != nil {
            return false
        }
        
        DispatchQueue.main.async {
            self.updateLoginButtonState()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButtonState()
    }
    
    private func updateLoginButtonState() {
        let isEmailFilled = !(emailTextField.text ?? "").isEmpty
        let isPasswordFilled = !(passwordTextField.text ?? "").isEmpty
        loginButton.setButtonState(isEnabled: isEmailFilled && isPasswordFilled)
    }
}
