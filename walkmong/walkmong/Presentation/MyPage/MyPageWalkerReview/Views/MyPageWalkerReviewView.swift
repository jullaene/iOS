//
//  MyPageWalkerReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MyPageWalkerReviewView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let filterContainerView = UIView()
    private var filterButton: UIButton = MyPageWalkerReviewView.createFilterButton()
    private let dogFilterStackView = UIStackView()
    private var filterView: FilterView?
    private var dimView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        filterContainerView.addSubviews(filterButton, dogFilterStackView)
        contentView.addSubview(filterContainerView)
        setupFilterButton()
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        dogFilterStackView.axis = .horizontal
        dogFilterStackView.spacing = 8
        dogFilterStackView.alignment = .center
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        filterContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(77)
        }
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(filterContainerView)
            make.leading.equalToSuperview().offset(20)
        }
        
        dogFilterStackView.snp.makeConstraints { make in
            make.leading.equalTo(filterButton.snp.trailing).offset(8)
            make.centerY.equalTo(filterContainerView)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func addDogFilter(name: String) {
        let button = UIButton.createStyledButton(
            type: .homeFilter,
            style: .profile,
            title: name
        )
        button.backgroundColor = .gray200
        
        dogFilterStackView.addArrangedSubview(button)
    }
    
    private func addReviewCells(reviews: [DogReviewModel]) {
        var previousView: UIView = filterContainerView
        
        for review in reviews {
            let reviewCell = WalkReviewCell()
            reviewCell.configure(with: review)
            contentView.addSubview(reviewCell)
            
            reviewCell.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            previousView = reviewCell
        }
        
        previousView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupFilterButton() {
        addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
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

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.addSubview(dimView!)
            }

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
        
        filterView.filters = ["최신순", "평점 높은 순", "평점 낮은 순"]

        filterView.onFilterSelected = { [weak self] selectedText in
            self?.updateFilterButtonTitle(with: selectedText)
        }
        
        filterView.onHideRequested = { [weak self] in
            self?.hideFilterView()
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(filterView)
            setupFilterViewConstraints()
            layoutIfNeeded()

            if let dimView = dimView {
                window.bringSubviewToFront(dimView)
                window.bringSubviewToFront(filterView)
            }

            filterView.animateShow(offset: 0, cornerRadius: 30)
        }
    }

    private func setupFilterViewAndHandlers() {
        guard let filterView = filterView else { return }
        filterView.onFilterSelected = { [weak self] selectedText in
            self?.updateFilterButtonTitle(with: selectedText)
        }
        filterView.onHideRequested = { [weak self] in
            self?.hideFilterView()
        }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(filterView)
            
            if let dimView = dimView {
                window.bringSubviewToFront(dimView)
                window.bringSubviewToFront(filterView)
            }
        }
        filterView.animateShow(offset: 0, cornerRadius: 30)
    }
    
    @objc private func hideFilterView() {
        filterView?.animateHide(withDuration: 0.4, offset: 228 + safeAreaInsets.bottom)
        dimView?.updateDimViewVisibility(isHidden: true)
    }
    
    private func setupFilterViewConstraints() {
        guard let filterView = filterView else { return }
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(228 + safeAreaInsets.bottom)
            make.bottom.equalToSuperview().offset(228 + safeAreaInsets.bottom)
        }
    }
    
    private func updateFilterButtonTitle(with title: String) {
        UIView.performWithoutAnimation {
            filterButton.subviews.forEach { $0.removeFromSuperview() }
            
            UIButton.configureCustomFilter(button: filterButton, style: .light, title: title)
            filterButton.backgroundColor = .gray200
            
            filterButton.layoutIfNeeded()
        }
    }
    
    // MARK: - Factory Method
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }

}
