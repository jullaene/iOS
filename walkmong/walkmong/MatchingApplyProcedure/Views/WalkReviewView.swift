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
    private let filterButton: UIButton = {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }()
    private var reviewCells: [UIView] = []

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints(navigationBarHeight: 0) // 초기값은 0으로 설정
        addReviewCells(count: 5)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .gray100
        
        // Add scrollView and contentView
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add filterButton
        contentView.addSubview(filterButton)
    }

    private func setupConstraints(navigationBarHeight: CGFloat) {
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(52) // 커스텀 네비게이션 바 높이를 반영
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        filterButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
    }

    // MARK: - Review Cells
    private func addReviewCells(count: Int) {
        let firstCellSpacing: CGFloat = 36
        let cellSpacing: CGFloat = 24
        let cellMargin: CGFloat = 20
        var previousView: UIView = filterButton

        for index in 1...count {
            let cell = UIView()
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 15
            contentView.addSubview(cell)
            reviewCells.append(cell)

            cell.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(cellMargin)
                make.trailing.equalToSuperview().offset(-cellMargin)
                make.height.equalTo(470)
                if index == 1 {
                    make.top.equalTo(previousView.snp.bottom).offset(firstCellSpacing) // 첫 셀 간격
                } else {
                    make.top.equalTo(previousView.snp.bottom).offset(cellSpacing) // 셀 간 간격
                }
            }

            previousView = cell
        }

        reviewCells.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(safeAreaInsets.bottom + 11)) // 마지막 셀 간격
        }
    }
}
