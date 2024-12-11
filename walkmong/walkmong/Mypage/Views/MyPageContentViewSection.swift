//
//  MyPageContentViewSection.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageContentViewSection: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
}
