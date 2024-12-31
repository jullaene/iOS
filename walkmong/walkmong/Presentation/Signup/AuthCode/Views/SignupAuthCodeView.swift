//
//  SignupAuthCodeView.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

protocol SignupAuthCodeViewDelegate: AnyObject {
    func didEnterCode(_ code: String)
}

final class SignupAuthCodeView: UIView {
    private let userEmail: String = "이메일 오류"
    
    private let titleLabel = MiddleTitleLabel(text: "계정 인증 코드를 확인해주세요")
    private let subtitleLabel = SubtitleLabel()
    private let authUpperLabel = CaptionLabel(text: "6자리 인증 코드", textColor: .gray500)
    private let stackView = UIStackView()
    private var textFields: [UITextField] = []
    private let nextButton = NextButton(text: "인증 코드 확인")
    
    weak var delegate: SignupAuthCodeViewDelegate?

    private let authTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.background = .none
        textField.font = UIFont(name: "Pretendard-Bold", size: 20)
        textField.textColor = .gray600
        textField.textContentType = .oneTimeCode
        textField.addCharacterSpacing()
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setUI()
        setConstraints()
        subtitleLabel.setContent("\(userEmail)으로 보내드린 인증코드로 로그인 하실 수 있습니다.", textColor: .mainBlue, image: .warningIconMainBlue)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(titleLabel,subtitleLabel,authUpperLabel,nextButton)
    }
    
    private func setUI() {
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        addSubview(stackView)

        for _ in 0..<6 {
            let textField = createTextField()
            textFields.append(textField)
            textField.delegate = self
            textField.snp.makeConstraints { make in
                make.width.equalTo(37)
                make.height.equalTo(49)
            }
            stackView.addArrangedSubview(textField)
        }
        
        textFields.first?.becomeFirstResponder()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(24)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        authUpperLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(authUpperLabel.snp.bottom).offset(12)
            make.height.equalTo(49)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }

    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.background = .none
        textField.font = UIFont(name: "Pretendard-Bold", size: 20)
        textField.textColor = .gray600
        textField.textContentType = .oneTimeCode
        textField.textAlignment = .center
        textField.backgroundColor = .gray100
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.keyboardType = .numberPad
        textField.tintColor = .clear
        textField.clearsOnInsertion = true
        return textField
    }
    
    private func getCode() -> String {
        return textFields.compactMap { $0.text }.joined()
    }
    
    @objc private func nextButtonTapped() {
        delegate?.didEnterCode(getCode())
    }
}

extension SignupAuthCodeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentIndex = textFields.firstIndex(of: textField) else { return false }
        nextButton.setButtonState(isEnabled: false)
        
        if string.count == 1 {
            textField.text = string
            
            if currentIndex < 5 {
                textFields[currentIndex + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                nextButton.setButtonState(isEnabled: true)
                delegate?.didEnterCode(getCode())
            }
            return false
        } else if string.isEmpty {
            textField.text = ""
            if currentIndex > 0 {
                textFields[currentIndex - 1].becomeFirstResponder()
            }
            return false
        }
        return false
    }

}
