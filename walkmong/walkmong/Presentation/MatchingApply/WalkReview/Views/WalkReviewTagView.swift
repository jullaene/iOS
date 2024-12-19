//
//  WalkReviewTagView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

class WalkReviewTagView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .green
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    func configure(with tags: [String]) {
        // 추후 태그 데이터를 기반으로 UI 업데이트 구현 가능
    }
}
