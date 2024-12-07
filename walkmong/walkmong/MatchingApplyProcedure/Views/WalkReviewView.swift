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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let filterButton = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
    
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
        backgroundColor = .gray100

        // Add scrollView and contentView
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add homeFilterButton to contentView
        contentView.addSubview(filterButton)
        filterButton.backgroundColor = .gray200
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // ScrollView가 전체 화면을 채우도록 설정
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // ScrollView의 내부를 채움
            make.width.equalToSuperview() // ScrollView의 수평 스크롤 방지
        }

        // Home Filter Button 기본 위치 설정
        filterButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
    }

    // MARK: - Public Methods
    func updateHomeFilterButtonPosition(navigationBarHeight: CGFloat) {
        filterButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(navigationBarHeight + 20)
        }
    }
}
