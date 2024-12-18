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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        filterContainerView.addSubview(filterButton)
        contentView.addSubview(filterContainerView)
        setupFilterButton()
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        dogFilterStackView.axis = .horizontal
        dogFilterStackView.spacing = 8
        dogFilterStackView.alignment = .center
        filterContainerView.addSubviews(filterButton, dogFilterStackView)
        
        addDogFilter(imageURL: "https://www.fitpetmall.com/wp-content/uploads/2022/11/shutterstock_196467692-1024x819.jpg", name: "봄별이")
        addDogFilter(imageURL: "", name: "새봄이")
        
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
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        dogFilterStackView.snp.makeConstraints { make in
            make.leading.equalTo(filterButton.snp.trailing).offset(8)
            make.centerY.equalTo(filterContainerView)
            make.trailing.lessThanOrEqualTo(contentView).offset(-20)
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
        
        if let lastCell = contentView.subviews.last {
            lastCell.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-20)
            }
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
    
    @objc private func filterButtonTapped() {
        setupDimViewIfNeeded()
        showFilterView()
    }
    
    private func setupDimViewIfNeeded() {
        if dimView == nil {
            dimView = UIView()
            configureDimView()
            contentView.addSubview(dimView!)
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
        
        contentView.addSubview(filterView)
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
