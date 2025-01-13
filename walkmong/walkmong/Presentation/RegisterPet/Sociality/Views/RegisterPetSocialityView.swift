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
    
    private let titleLabel = MiddleTitleLabel(text: "산책자에게 전달할 메시지")
    
    weak var delegate: RegisterPetSocialityViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        
    }
    
    private func setConstraints() {
        
    }

}
