//
//  RegisterPetInfoView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

protocol RegisterPetInfoViewDelegate: AnyObject {
    func didTapNextButton()
}

final class RegisterPetInfoView: UIView {
    
    weak var delegate: RegisterPetInfoViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
