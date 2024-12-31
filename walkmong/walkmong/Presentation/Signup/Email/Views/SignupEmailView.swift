//
//  SignupEmailView.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

protocol SignupEmailViewDelegate: AnyObject {
    func didTapNextButton()
}

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
    
    private var debounceTimer: Timer?
    
    weak var delegate: SignupEmailViewDelegate?

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
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        //TODO: 인증 코드 API 호출 + 화면 전환
        debounceTimer?.invalidate()
        validateEmailInput(in: emailTextField)
        
        if nextButton.isEnabled {
            // TODO: 인증 코드 API 호출 + 화면 전환
            print("nextButton Action")
            delegate?.didTapNextButton()
        } else {
            print("이메일이 유효하지 않아 동작하지 않습니다.")
        }
    }
    
}

extension SignupEmailView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        nextButton.setButtonState(isEnabled: false)
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.validateEmailInput(in: textField)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonTapped()
        return true
    }
    
    private func validateEmailInput(in textField: UITextField) {
        if let text = textField.text, isValidEmail(text) {
            emailTextFieldWithSubtitle.showSubtitleText(false)
            nextButton.setButtonState(isEnabled: true)
            
            //TODO: 이메일 중복 검사 API 호출
//            if {requestAPI} {
//                emailTextFieldWithSubtitle.shakeSubtitleLabel()
//                emailTextFieldWithSubtitle.showSubtitleText(true)
//                nextButton.setButtonState(isEnabled: true)
//                emailTextFieldWithSubtitle.setSubtitleText(textColor: ., text: "이미 가입된 이메일 주소입니다. 다른 이메일을 입력해주세요.")
//            }else {
//                nextButton.setButtonState(isEnabled: false)
//                emailTextFieldWithSubtitle.showSubtitleText(false)
//            }
            
        } else {
            nextButton.setButtonState(isEnabled: false)
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
