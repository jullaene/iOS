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
    
    private let titleLabel = MiddleTitleLabel(text: "반려견의 사회성 및 성향을 알려주세요.")
    
    weak var delegate: RegisterPetMessageViewDelegate?
    
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
