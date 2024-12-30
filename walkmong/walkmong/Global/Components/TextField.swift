//
//  TextField.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class TextField: UITextField {
    
    init(placeHolderText: String, keyboardType: UIKeyboardType, shouldHideText: Bool, textContentType: UITextContentType) {
        super.init(frame: .zero)
        self.textColor = .gray600
        self.font = UIFont(name:"Pretendard-Medium",size: 16)
        self.backgroundColor = .gray100
        self.layer.cornerRadius = 5
        self.keyboardType = keyboardType
        self.placeholder = placeHolderText
        self.textContentType = textContentType
        self.isSecureTextEntry = shouldHideText
        self.rightViewMode = shouldHideText ? .always : .never
        self.rightView = shouldHideText ? secureButton : nil
        self.setPlaceholderColor(.gray300)
        self.addCharacterSpacing()
    }
    
    private lazy var secureButton: UIButton = {
        let button = UIButton()
        button.setImage(.blind, for: .normal)
        button.setImage(.eye, for: .selected)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 28, y: 15, width: bounds.height - 30, height: bounds.height - 30)
    }
    
}
