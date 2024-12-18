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
    
    private let filterContainerView = UIView()
    private var filterButton: UIButton = MyPageOwnerReviewView.createFilterButton()
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
        
        filterContainerView.addSubview(filterButton)
        addSubview(filterContainerView)
        setupFilterButton()
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        dogFilterStackView.axis = .horizontal
        dogFilterStackView.spacing = 8
        dogFilterStackView.alignment = .center
        filterContainerView.addSubview(dogFilterStackView)
        
        addDogFilter(imageURL: "https://www.fitpetmall.com/wp-content/uploads/2022/11/shutterstock_196467692-1024x819.jpg", name: "봄별이")
        addDogFilter(imageURL: "", name: "새봄이")
    }
    
    private func setupConstraints() {
        filterContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(77)
        }
        
        filterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        dogFilterStackView.snp.makeConstraints { make in
            make.leading.equalTo(filterButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func addDogFilter(imageURL: String, name: String) {
        let button = UIButton.createStyledButton(
            type: .homeFilter,
            style: .profile,
            title: name,
            imageUrl: imageURL
        )
        
        dogFilterStackView.addArrangedSubview(button)
    }
    
    
    private func setupFilterButton() {
        addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func filterButtonTapped() {
        setupDimViewIfNeeded()
        showFilterView()
    }
    
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
    
    // MARK: - Factory Method
    private static func createFilterButton() -> UIButton {
        let button = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
        button.backgroundColor = .gray200
        return button
    }
}
