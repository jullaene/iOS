//
//  MyPageOwnerReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/18/24.
//

import UIKit
import SnapKit
import Kingfisher

class MyPageOwnerReviewView: UIView {
    
    let walkReviewTotalRatingView = WalkReviewTotalRatingView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogFilterScrollView = UIScrollView()
    private var filterButton: UIButton = MyPageOwnerReviewView.createFilterButton()
    private let dogFilterStackView = UIStackView()
    private var filterView: FilterView?
    private var dimView: UIView?
    
    func configure(with models: [DogReviewModel]) {
        addReviewCells(reviews: models)
    }
    
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

        contentView.addSubview(dogFilterScrollView)
        dogFilterScrollView.addSubviews(filterButton, dogFilterStackView)

        setupFilterButton()

        dogFilterScrollView.isScrollEnabled = true
        dogFilterScrollView.showsHorizontalScrollIndicator = true
        dogFilterScrollView.alwaysBounceHorizontal = true
        dogFilterScrollView.alwaysBounceVertical = false
        dogFilterScrollView.isUserInteractionEnabled = true
        dogFilterScrollView.showsHorizontalScrollIndicator = false

        dogFilterStackView.axis = .horizontal
        dogFilterStackView.spacing = 8
        dogFilterStackView.alignment = .center

        filterButton.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        dogFilterScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(37)
        }
        
        filterButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(37)
        }
        
        dogFilterStackView.snp.makeConstraints { make in
            make.leading.equalTo(filterButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(filterButton)
        }
    }
    
    private func addDogFilter(name: String, action: Selector? = nil) {
        let button = UIButton.createStyledButton(
            type: .homeFilter,
            style: .profile,
            title: name
        )
        button.backgroundColor = .gray200
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        dogFilterStackView.addArrangedSubview(button)
    }
    
    func updateDogFilters(with dogs: [DogListItem]) {
        let existingNames = dogFilterStackView.arrangedSubviews.compactMap {
            ($0 as? UIButton)?.title(for: .normal)
        }
        let newNames = dogs.map { $0.dogName }
        
        let filtersToAdd = newNames.filter { !existingNames.contains($0) }
        for name in filtersToAdd {
            addDogFilter(name: name)
        }
    }
    
    private func addReviewCells(reviews: [DogReviewModel]) {
        var previousView: UIView = dogFilterScrollView
        
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
        dogFilterScrollView.addSubview(filterButton)
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
            dimView = createDimView()
            guard let window = UIApplication.shared.keyWindow else { return }
            window.addSubview(dimView!)
            setupDimViewConstraints()
        }
        dimView?.updateDimViewVisibility(isHidden: false)
    }

    private func createDimView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideFilterView)))
        return view
    }

    private func setupDimViewConstraints() {
        dimView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Filter View Handling
    private func showFilterView() {
        guard let window = UIApplication.shared.keyWindow else { return }

        if dimView == nil {
            dimView = createDimView()
            window.addSubview(dimView!)
            setupDimViewConstraints()
        }
        
        if filterView == nil {
            filterView = createFilterView()
            window.addSubview(filterView!)
            setupFilterViewConstraints()
        }
        
        window.bringSubviewToFront(dimView!)
        window.bringSubviewToFront(filterView!)

        layoutIfNeeded()
        filterView?.animateShow(offset: 0, cornerRadius: 30)
        dimView?.updateDimViewVisibility(isHidden: false)
    }

    private func createFilterView() -> FilterView {
        let filterView = FilterView()
        filterView.onFilterSelected = { [weak self] selectedText in
            self?.updateFilterButtonTitle(with: selectedText)
        }
        filterView.onHideRequested = { [weak self] in
            self?.hideFilterView()
        }
        return filterView
    }
    
    @objc private func hideFilterView() {
        filterView?.animateHide(withDuration: 0.4, offset: 178 + safeAreaInsets.bottom)
        dimView?.updateDimViewVisibility(isHidden: true)
    }
    
    private func setupFilterViewConstraints() {
        guard let filterView = filterView else { return }
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(178 + safeAreaInsets.bottom)
            make.bottom.equalToSuperview().offset(178 + safeAreaInsets.bottom)
        }
    }
    
    private func updateFilterButtonTitle(with title: String) {
        filterButton.subviews.forEach { $0.removeFromSuperview() }
        UIButton.configureCustomFilter(button: filterButton, style: .light, title: title)
        filterButton.backgroundColor = .gray200
        filterButton.layoutIfNeeded()
    }
    
    // MARK: - Factory Method
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }
    
    func updateReviews(with reviews: [DogReviewModel]) {
        contentView.subviews.filter { $0 is WalkReviewCell }.forEach { $0.removeFromSuperview() }
        
        var previousView: UIView = dogFilterScrollView
        
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

}
