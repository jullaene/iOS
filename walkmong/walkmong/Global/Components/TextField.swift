//
//  TextField.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class TextField: UITextField, UITextFieldDelegate {
    
    private var maxCharacters: Int?
    private var allowSpaces: Bool
    private var allowOnlyKoreanAndEnglish: Bool
    private var shouldClearTextOnFocus: Bool?
    
    init(
        placeHolderText: String,
        keyboardType: UIKeyboardType,
        shouldHideText: Bool,
        textContentType: UITextContentType?,
        maxCharacters: Int = 256,
        allowSpaces: Bool = true,
        allowOnlyKoreanAndEnglish: Bool = false,
        useCustomDelegate: Bool = false,
        shouldClearTextOnFocus: Bool = false
    ) {
        self.maxCharacters = maxCharacters
        self.allowSpaces = allowSpaces
        self.allowOnlyKoreanAndEnglish = allowOnlyKoreanAndEnglish
        super.init(frame: .zero)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 46))
        
        self.textColor = .gray600
        self.font = UIFont(name: "Pretendard-Medium", size: 16)
        self.backgroundColor = .gray100
        self.layer.cornerRadius = 5
        self.leftView = paddingView
        self.leftViewMode = .always
        self.keyboardType = keyboardType
        self.placeholder = placeHolderText
        if let textContentType {
            self.textContentType = textContentType
        }
        self.isSecureTextEntry = shouldHideText
        self.rightViewMode = shouldHideText ? .always : .never
        self.rightView = shouldHideText ? secureButton : nil
        self.setPlaceholderColor(.gray300)
        self.addCharacterSpacing()
        if !useCustomDelegate { self.delegate = self }
    }
    
    private lazy var secureButton: UIButton = {
        let button = UIButton()
        button.setImage(.blind, for: .normal)
        button.setImage(.eye, for: .selected)
        button.addTarget(self, action: #selector(secureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 28, y: 15, width: bounds.height - 30, height: bounds.height - 30)
    }
    
    @objc private func secureButtonTapped() {
        isSecureTextEntry.toggle()
        secureButton.isSelected.toggle()
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 공백 제한
        if !allowSpaces && string.contains(" ") {
            return false
        }
        
        // 한글/영문만 입력 가능
        if allowOnlyKoreanAndEnglish {
            let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z]*$"
            let regex = try? NSRegularExpression(pattern: pattern)
            if let regex = regex {
                let range = NSRange(location: 0, length: string.utf16.count)
                if !regex.matches(in: string, options: [], range: range).isEmpty == false {
                    return false
                }
            }
        }
        
        // 최대 글자수 제한
        if let maxCharacters = maxCharacters, let currentText = textField.text {
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return updatedText.count <= maxCharacters
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 포커스가 갈 때 텍스트를 지움
        if let shouldClearTextOnFocus{
            textField.text = ""
        }
    }

}
