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
    private var dimView: UIView?
    private var filterView: FilterView?

    // MARK: - Constants
    private enum Layout {
        static let topOffset: CGFloat = 52
        static let filterButtonMargin: CGFloat = 20
        static let firstCellSpacing: CGFloat = 36
        static let cellSpacing: CGFloat = 24
        static let cellMargin: CGFloat = 20
        static let bottomSpacing: CGFloat = 20
        static let filterViewHeight: CGFloat = 178
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        addReviewCells(count: 5)
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

        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
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
    }

    // MARK: - Add Review Cells
    private func addReviewCells(count: Int) {
        var previousView: UIView = filterButton

        for index in 1...count {
            let cell = WalkReviewCell()
            contentView.addSubview(cell)

            cell.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(Layout.cellMargin)
                make.top.equalTo(previousView.snp.bottom).offset(index == 1 ? Layout.firstCellSpacing : Layout.cellSpacing)
            }

            previousView = cell
        }

        previousView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Layout.bottomSpacing)
        }
    }

    // MARK: - Button Action
    @objc private func filterButtonTapped() {
        setupDimView()
        showFilterView()
    }

    // MARK: - Dim View Setup
    private func setupDimView() {
        if dimView == nil {
            dimView = UIView()
            dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimView?.isHidden = true
            addSubview(dimView!)

            dimView?.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterView))
            dimView?.addGestureRecognizer(tapGesture)
        }
        dimView?.updateDimViewVisibility(isHidden: false)
    }

    // MARK: - Show Filter View
    private func showFilterView() {
        guard filterView == nil else { return }
        filterView = FilterView()
        addSubview(filterView!)

        filterView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Layout.filterViewHeight + safeAreaInsets.bottom)
            make.bottom.equalToSuperview().offset(Layout.filterViewHeight + safeAreaInsets.bottom)
        }
        layoutIfNeeded()
        filterView?.animateShow(offset: 0, cornerRadius: 30)
    }

    // MARK: - Hide Filter View
    @objc private func hideFilterView() {
        filterView?.animateHide(offset: Layout.filterViewHeight + safeAreaInsets.bottom)
        dimView?.updateDimViewVisibility(isHidden: true)
    }

    // MARK: - Factory Method
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }
}
