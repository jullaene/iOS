//
//  WalkInfoView.swift
//  walkmong
//
//  Created by 신호연 on 11/11/24.
//

import UIKit

class WalkInfoView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray // 배경색 설정
        layer.cornerRadius = 20 // 둥근 모서리 설정
    }
}
