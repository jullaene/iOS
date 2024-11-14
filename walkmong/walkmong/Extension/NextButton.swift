//
//  NextButton.swift
//  walkmong
//
//  Created by 황채웅 on 11/15/24.
//

import UIKit

class NextButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        self.titleLabel?.textColor = .white
        self.backgroundColor = .gray300
        self.layer.cornerRadius = 15
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints(){
        self.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(46)
        }
    }
}
