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
        static let firstCellSpacing: CGFloat = 28
        static let cellSpacing: CGFloat = 20
        static let cellMargin: CGFloat = 20
        static let bottomSpacing: CGFloat = 20
        static let filterViewHeight: CGFloat = 178
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with models: [DogReviewModel]) {
        addReviewCells(models: models)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .gray100
        setupScrollView()
        setupFilterButton()
        setupFilterButtonConstraints()
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func setupFilterButton() {
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
            make.height.equalTo(scrollView.snp.height).priority(.low)
        }
    }

    private func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Layout.topOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }

    private func setupFilterButtonConstraints() {
        filterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.filterButtonMargin)
            make.leading.equalToSuperview().offset(Layout.filterButtonMargin)
        }
    }

    // MARK: - Add Review Cells
    private func addReviewCells(models: [DogReviewModel]) {
        var previousView: UIView = filterButton

        for model in models {
            let cell = WalkReviewCell()
            cell.configure(with: model)
            contentView.addSubview(cell)
            cell.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(Layout.cellMargin)
                make.top.equalTo(previousView.snp.bottom).offset(previousView === filterButton ? Layout.firstCellSpacing : Layout.cellSpacing)
            }
            previousView = cell
        }

        previousView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Layout.bottomSpacing)
        }
    }

    private func setupCellConstraints(cell: UIView, previousView: UIView, isFirst: Bool) {
        cell.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Layout.cellMargin)
            make.top.equalTo(previousView.snp.bottom).offset(isFirst ? Layout.firstCellSpacing : Layout.cellSpacing)
        }
    }

    private func setupLastCellConstraint(lastView: UIView) {
        lastView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Layout.bottomSpacing)
        }
    }

    // MARK: - Button Actions
    @objc private func filterButtonTapped() {
        setupDimViewIfNeeded()
        showFilterView()
    }

    // MARK: - Dim View Setup
    private func setupDimViewIfNeeded() {
        if dimView == nil {
            dimView = UIView()
            configureDimView()
            addSubview(dimView!)
            setupDimViewConstraints()
        }
        dimView?.updateDimViewVisibility(isHidden: false)
    }

    private func configureDimView() {
        dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimView?.isHidden = true
        dimView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideFilterView)))
    }

    private func setupDimViewConstraints() {
        dimView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Filter View Handling
    private func showFilterView() {
        if let filterView = filterView {
            filterView.isHidden = false
            filterView.animateShow(offset: 0, cornerRadius: 30)
            return
        }

        filterView = FilterView()
        guard let filterView = filterView else { return }
        
        filterView.onFilterSelected = { [weak self] selectedText in
            self?.updateFilterButtonTitle(with: selectedText)
        }
        
        filterView.onHideRequested = { [weak self] in
            self?.hideFilterView()
        }
        
        addSubview(filterView)
        setupFilterViewConstraints()
        layoutIfNeeded()
        filterView.animateShow(offset: 0, cornerRadius: 30)
    }

    private func updateFilterButtonTitle(with title: String) {
        UIView.performWithoutAnimation {
            filterButton.subviews.forEach { $0.removeFromSuperview() }
            
            UIButton.configureCustomFilter(button: filterButton, style: .light, title: title)
            filterButton.backgroundColor = .gray200
            
            filterButton.layoutIfNeeded()
        }
    }

    @objc private func hideFilterView() {
        filterView?.animateHide(withDuration: 0.4, offset: Layout.filterViewHeight + safeAreaInsets.bottom)
        dimView?.updateDimViewVisibility(isHidden: true)
    }

    private func setupFilterViewConstraints() {
        guard let filterView = filterView else { return }
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Layout.filterViewHeight + safeAreaInsets.bottom)
            make.bottom.equalToSuperview().offset(Layout.filterViewHeight + safeAreaInsets.bottom)
        }
    }

    // MARK: - Factory Method
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }
}
