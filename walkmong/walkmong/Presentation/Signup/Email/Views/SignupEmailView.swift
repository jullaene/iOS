//
//  SignupEmailView.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class SignupEmailView: UIView {
    
    private let titleLabel = MiddleTitleLabel(text: "이메일을 입력해주세요.")
    
    private let emailTextField = TextField(
        placeHolderText: "이메일을 입력해주세요.",
        keyboardType: .emailAddress,
        shouldHideText: false,
        textContentType: .emailAddress
    )
    
    private let emailTextFieldWithSubtitle: TextFieldWithSubtitle
    
    private let nextButton = NextButton(text: "인증코드 받기")

    override init(frame: CGRect) {
        self.emailTextFieldWithSubtitle = TextFieldWithSubtitle(textField: emailTextField)
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setButtonAction()
        emailTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(titleLabel, emailTextFieldWithSubtitle, nextButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(24)
        }
        emailTextFieldWithSubtitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
    }
    
    private func setButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    @objc private func nextButtonAction() {
        //TODO: 인증 코드 API 호출 + 화면 전환
        print("nextButton Action")
    }
    
}

extension SignupEmailView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text, isValidEmail(text) {
            emailTextFieldWithSubtitle.showSubtitleText(false)
            nextButton.setButtonState(isEnabled: true)
            //TODO: 이메일 중복 검사 API 호출
//            if {requestAPI} {
//                emailTextFieldWithSubtitle.shakeSubtitleLabel()
//                emailTextFieldWithSubtitle.showSubtitleText(true)
//                emailTextFieldWithSubtitle.setSubtitleText(textColor: ., text: "이미 가입된 이메일 주소입니다. 다른 이메일을 입력해주세요.")
//            }else {
//                emailTextFieldWithSubtitle.showSubtitleText(false)
//            }
        }else {
            emailTextFieldWithSubtitle.shakeSubtitleLabel()
            emailTextFieldWithSubtitle.showSubtitleText(true)
            emailTextFieldWithSubtitle.setSubtitleText(textColor: .negative, text: "올바른 이메일 형식을 입력해주세요.")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

}
