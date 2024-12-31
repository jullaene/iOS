//
//  SignupEmailView.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class SignupEmailView: UIView {
    
    private let emailTextField = TextField(placeHolderText: "이메일을 입력해주세요",
                                           keyboardType: .emailAddress,
                                           shouldHideText: false,
                                           textContentType: .emailAddress)
    
    private let emailTextFieldWithSubtitle = TextFieldWithSubtitle(frame: <#T##CGRect#>, textField: <#T##TextField#>)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
