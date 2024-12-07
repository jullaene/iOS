//
//  WalkReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class WalkReviewView: UIView {

    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "산책 후기"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
