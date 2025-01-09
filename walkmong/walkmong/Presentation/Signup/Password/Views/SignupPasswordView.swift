//
//  SignupPasswordView.swift
//  walkmong
//
//  Created by 황채웅 on 1/1/25.
//

import UIKit

protocol SignupPasswordViewDelegate: AnyObject {
    func didTapNextButton(password: String)
}

final class SignupPasswordView: UIView {
    
    private let titleLabel = MiddleTitleLabel(text: "비밀번호를 입력해주세요.")
    
    private let checkPasswordLabel = UpperTitleLabel(text: "비밀번호 확인")
    
    private let passwordTextField = TextField(placeHolderText: "비밀번호를 입력해주세요", keyboardType: .default, shouldHideText: true, textContentType: .newPassword)
    private var passwordTextFieldWithSubtitle: TextFieldWithSubtitle
    
    private let passwordRewriteTextField = TextField(placeHolderText: "비밀번호를 다시 입력해주세요", keyboardType: .default, shouldHideText: true, textContentType: .newPassword)
    private var passwordRewriteTextFieldWithSubtitle: TextFieldWithSubtitle
    
    private let nextButton = NextButton(text: "다음으로")
    
    weak var delegate: SignupPasswordViewDelegate?

    override init(frame: CGRect) {
        passwordTextFieldWithSubtitle = TextFieldWithSubtitle(textField: passwordTextField)
        passwordRewriteTextFieldWithSubtitle = TextFieldWithSubtitle(textField: passwordRewriteTextField)
        super.init(frame: frame)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        setUI()
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        passwordTextFieldWithSubtitle.setSubtitleText(textColor: .mainBlue, text: "영문 대·소문자/특수문자/숫자 중 2가지 이상 조합, 8~20자 조합", image: .warningIconMainBlue)
        passwordRewriteTextFieldWithSubtitle.showSubtitleText(false)
        passwordTextField.delegate = self
        passwordRewriteTextField.delegate = self
    }
    
    private func addSubview() {
        addSubviews(passwordTextFieldWithSubtitle, passwordRewriteTextFieldWithSubtitle, nextButton, titleLabel, checkPasswordLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(24)
        }
        passwordTextFieldWithSubtitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        checkPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldWithSubtitle.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        passwordRewriteTextFieldWithSubtitle.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        passwordRewriteTextField.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 && password.count <= 20 else {
            return false
        }

        let uppercaseSet = CharacterSet.uppercaseLetters
        let lowercaseSet = CharacterSet.lowercaseLetters
        let digitSet = CharacterSet.decimalDigits
        let specialCharacterSet = CharacterSet.punctuationCharacters.union(.symbols)

        var hasUppercase = false
        var hasLowercase = false
        var hasDigit = false
        var hasSpecialCharacter = false

        for char in password.unicodeScalars {
            if uppercaseSet.contains(char) {
                hasUppercase = true
            } else if lowercaseSet.contains(char) {
                hasLowercase = true
            } else if digitSet.contains(char) {
                hasDigit = true
            } else if specialCharacterSet.contains(char) {
                hasSpecialCharacter = true
            }
        }

        let validTypes = [hasUppercase, hasLowercase, hasDigit, hasSpecialCharacter].filter { $0 }
        return validTypes.count >= 2
    }
    
    @objc private func didTapNextButton() {
        if let password = passwordTextField.text {
            delegate?.didTapNextButton(password: password)
        }
    }
}

extension SignupPasswordView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let password = passwordTextField.text, isValidPassword(password){
            passwordTextFieldWithSubtitle.setSubtitleText(textColor: .mainBlue, text: "영문 대·소문자/특수문자/숫자 중 2가지 이상 조합, 8~20자 조합", image: .warningIconMainBlue)
            if passwordTextField.text == passwordRewriteTextField.text {
                // 재입력 통과
                passwordRewriteTextFieldWithSubtitle.showSubtitleText(false)
                nextButton.setButtonState(isEnabled: true)
            }else {
                // 재입력 거부
                passwordTextFieldWithSubtitle.showSubtitleText(true)
                
                passwordRewriteTextFieldWithSubtitle.showSubtitleText(true)
                passwordRewriteTextFieldWithSubtitle.setSubtitleText(textColor: .negative, text: "비밀번호가 다릅니다.", image: .warningIconNegative)
                passwordRewriteTextFieldWithSubtitle.shakeSubtitleLabel()
                nextButton.setButtonState(isEnabled: false)
            }
        }else {
            // 새로운 비밀번호 거부
            passwordTextFieldWithSubtitle.showSubtitleText(true)
            passwordTextFieldWithSubtitle.setSubtitleText(textColor: .negative, text: "영문 대·소문자/특수문자/숫자 중 2가지 이상 조합, 8~20자 조합", image: .warningIconNegative)
            passwordTextFieldWithSubtitle.shakeSubtitleLabel()
            
            passwordRewriteTextFieldWithSubtitle.showSubtitleText(false)
            passwordRewriteTextField.text = ""
            nextButton.setButtonState(isEnabled: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
