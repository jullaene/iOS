//
//  MyPageOwnerReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/18/24.
//

import UIKit
import SnapKit

class MyPageOwnerReviewView: UIView {
    
    // MARK: - Properties
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
    }
    
    private func setupConstraints() {
    }
}
