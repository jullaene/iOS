//
//  RegisterPetSocialityView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

protocol RegisterPetSocialityViewProtocol: AnyObject {
    func didTapNextButton()
}

final class RegisterPetSocialityView: UIView {
    
    weak var delegate: RegisterPetSocialityViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
