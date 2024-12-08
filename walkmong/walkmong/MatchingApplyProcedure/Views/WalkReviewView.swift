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
        showFilterView()
    }

    // MARK: - Dim View Setup
    private func setupDimView() {
        if dimView == nil {
            dimView = UIView()
            dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimView?.alpha = 0 // 초기 상태를 명확히 설정
            dimView?.isHidden = true
            addSubview(dimView!)

            dimView?.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterView))
            dimView?.addGestureRecognizer(tapGesture)
        }
    }

    // MARK: - Show Filter View
    private func showFilterView() {
        setupDimView()

        // Dim View 초기 상태 설정
        dimView?.isHidden = false
        dimView?.alpha = 0 // 애니메이션 전에 투명하게 설정

        // 필터 뷰 추가
        if filterView == nil {
            filterView = FilterView()
            filterView?.layer.cornerRadius = 30
            filterView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            addSubview(filterView!)

            filterView?.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(Layout.filterViewHeight + safeAreaInsets.bottom)
                // 초기 상태 명확히 설정: 화면 아래로 숨기기
                make.bottom.equalToSuperview().offset(Layout.filterViewHeight + safeAreaInsets.bottom)
            }

            // 초기 레이아웃 강제 적용
            self.layoutIfNeeded()
        }

        // Dim View와 필터 뷰 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.dimView?.alpha = 1.0 // Dim 효과 점차 나타나기
            self.filterView?.snp.updateConstraints { make in
                make.bottom.equalToSuperview() // 필터 뷰 올라오기
            }
            self.layoutIfNeeded()
        })
    }

    // MARK: - Hide Filter View
    @objc private func hideFilterView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.dimView?.alpha = 0.0 // Dim 효과 점차 사라지기
            self.filterView?.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(Layout.filterViewHeight + self.safeAreaInsets.bottom) // self. 명시
            }
            self.layoutIfNeeded()
        }) { [weak self] _ in
            self?.dimView?.isHidden = true
        }
    }

    // MARK: - Factory Method
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }
}
