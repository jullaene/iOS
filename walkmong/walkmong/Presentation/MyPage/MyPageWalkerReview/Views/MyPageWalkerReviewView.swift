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
        
        filterContainerView.addSubview(filterButton)
        contentView.addSubview(filterContainerView)
        setupFilterButton()
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        setupDummyReviews()
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
    
    private func setupDummyReviews() {
        let dummyReviews = [
            DogReviewModel(
                profileData: DogReviewModel.ProfileData(
                    image: nil,
                    reviewerId: "reviewer123",
                    walkDate: "2024년 12월 1일"
                ),
                circleTags: [],
                photos: [],
                reviewText: "연락을 당일에 30분 안보셔서 힘들었어요. 사전 산책 가능하시다고 하시고서는 연락도 안보여서.. 힘들었습니다."
            ),
            DogReviewModel(
                profileData: DogReviewModel.ProfileData(
                    image: nil,
                    reviewerId: "reviewer456",
                    walkDate: "2024년 12월 2일"
                ),
                circleTags: [],
                photos: [],
                reviewText: "산책은 즐거웠지만, 강아지 상태에 대한 피드백이 부족했어요."
            )
        ]
        addReviewCells(reviews: dummyReviews)
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
            if let window = UIApplication.shared.keyWindow {
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
        
        if let window = UIApplication.shared.keyWindow {
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
        if let window = UIApplication.shared.keyWindow {
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
