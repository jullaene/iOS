//
//  RegisterPetMessageView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

protocol RegisterPetMessageViewDelegate: AnyObject {
    func didTapNextButton()
}

final class RegisterPetMessageView: UIView {
    
    weak var delegate: RegisterPetMessageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
