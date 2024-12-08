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
    private let filterButton = WalkReviewView.createFilterButton()
    private var reviewCells: [WalkReviewCell] = []
    private let filterView = FilterView()

    // MARK: - Constants
    private enum Layout {
        static let topOffset: CGFloat = 52
        static let filterButtonMargin: CGFloat = 20
        static let firstCellSpacing: CGFloat = 36
        static let cellSpacing: CGFloat = 24
        static let cellMargin: CGFloat = 20
        static let bottomSpacing: CGFloat = 20
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        addReviewCells(count: 5)
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .gray100
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(filterButton)
        addSubview(filterView)
        filterView.isHidden = true
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Layout.topOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        filterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.filterButtonMargin)
            make.leading.equalToSuperview().offset(Layout.filterButtonMargin)
        }

        filterView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(safeAreaInsets.bottom + 178)
        }
    }

    // MARK: - Add Review Cells
    private func addReviewCells(count: Int) {
        var previousView: UIView = filterButton

        for index in 1...count {
            let cell = WalkReviewCell()
            contentView.addSubview(cell)
            reviewCells.append(cell)

            cell.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(Layout.cellMargin)
                make.top.equalTo(previousView.snp.bottom).offset(index == 1 ? Layout.firstCellSpacing : Layout.cellSpacing)
            }

            previousView = cell
        }

        reviewCells.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Layout.bottomSpacing)
        }
    }

    // MARK: - Actions
    private func setupActions() {
        filterButton.addTarget(self, action: #selector(toggleFilterView), for: .touchUpInside)
    }

    @objc private func toggleFilterView() {
        filterView.isHidden.toggle()
    }

    // MARK: - Factory Methods
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }
}
