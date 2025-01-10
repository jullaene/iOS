//
//  SignupEmailView.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

protocol SignupEmailViewDelegate: AnyObject {
    func didTapNextButton(with email: String) async
    func didTapEmailCheckButton(with email: String) async -> Bool
}

final class SignupEmailView: UIView {
    
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
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func didTapNextButton() {
        debounceTimer?.invalidate()
        validateEmailInput(in: emailTextField)
        
        if nextButton.isEnabled {
            print("nextButton Action")
            Task {
                await delegate?.didTapNextButton(with: emailTextField.text ?? "")
            }
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
        didTapNextButton()
        return true
    }
    
    private func validateEmailInput(in textField: UITextField) {
        guard let text = textField.text else { return }

        // 이메일 형식 유효성 검사
        if isValidEmail(text) {
            // 이메일 형식이 유효한 경우 네트워크 요청
            Task {
                if let isAvailable = await delegate?.didTapEmailCheckButton(with: text) {
                    print(isAvailable)
                    handleEmailCheckResult(isAvailable: isAvailable)
                } else {
                    // delegate가 nil이거나 응답이 없을 경우
                    showErrorForEmailCheck()
                }
            }
        } else {
            // 이메일 형식이 잘못된 경우
            handleInvalidEmailFormat()
        }
    }

    private func handleEmailCheckResult(isAvailable: Bool) {
        if isAvailable {
            // 이메일 사용 가능
            emailTextFieldWithSubtitle.setSubtitleText(
                textColor: .mainBlue,
                text: "사용 가능한 이메일입니다.",
                image: .warningIconMainBlue
            )
            emailTextFieldWithSubtitle.showSubtitleText(true)
            nextButton.setButtonState(isEnabled: true)
        } else {
            // 이메일 중복
            emailTextFieldWithSubtitle.setSubtitleText(
                textColor: .negative,
                text: "이미 사용 중인 이메일입니다.",
                image: .warningIconNegative
            )
            emailTextFieldWithSubtitle.showSubtitleText(true)
            emailTextFieldWithSubtitle.shakeSubtitleLabel()
            nextButton.setButtonState(isEnabled: false)
        }
    }

    private func handleInvalidEmailFormat() {
        emailTextFieldWithSubtitle.setSubtitleText(
            textColor: .negative,
            text: "올바른 이메일 형식을 입력해주세요.",
            image: .warningIconNegative
        )
        emailTextFieldWithSubtitle.showSubtitleText(true)
        emailTextFieldWithSubtitle.shakeSubtitleLabel()
        nextButton.setButtonState(isEnabled: false)
    }

    private func showErrorForEmailCheck() {
        emailTextFieldWithSubtitle.setSubtitleText(
            textColor: .negative,
            text: "이메일 확인 중 오류가 발생했습니다. 다시 시도해주세요.",
            image: .warningIconNegative
        )
        emailTextFieldWithSubtitle.showSubtitleText(true)
        nextButton.setButtonState(isEnabled: false)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
