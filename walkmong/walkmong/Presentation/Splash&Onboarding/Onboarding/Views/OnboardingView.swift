//
//  OnboardingView.swift
//  walkmong
//
//  Created by 신호연 on 1/2/25.
//

import UIKit
import SnapKit

final class OnboardingView: UIView, UIScrollViewDelegate {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    let nextButton: UIButton = UIButton.createStyledButton(type: .large, style: .dark, title: "다음으로")
    
    private let slides: [(image: String, title: String, description: String)] = [
        ("onboardingIllustration1", "믿을 수 있는 이웃과 함께", "모든 사용자는 본인 인증과 신원 확인 절차를 거친\n신뢰할 수 있는 이웃이에요"),
        ("onboardingIllustration2", "무료로 부담 없이", "믿을 수 있는 이웃에게 무료로 부담 없이\n산책을 맡길 수 있어요"),
        ("onboardingIllustration3", "산책을 통한 즐거움을", "반려견과의 교감을 통해 산책자는 소소한 기쁨과\n즐거움을 경험할 수 있어요"),
        ("onboardingIllustration4", "반려견의 안전한 산책을", "산책 중 1:1 연락과 실시간 위치 확인으로\n반려견의 안전을 확인할 수 있어요")
    ]
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        addSubviews(scrollView, pageControl, nextButton)
        
        setupSlides()
        setupPageControl()
    }
    
    private func setupSlides() {
        for (index, slide) in slides.enumerated() {
            let containerView = UIView()
            scrollView.addSubview(containerView)
            
            let imageView = UIImageView(image: UIImage(named: slide.image))
            imageView.contentMode = .scaleAspectFit
            containerView.addSubview(imageView)
            
            let titleLabel = LargeTitleLabel(text: slide.title)
            titleLabel.textAlignment = .center
            containerView.addSubview(titleLabel)
            
            let descriptionLabel = MainParagraphLabel(text: slide.description)
            descriptionLabel.textAlignment = .center
            descriptionLabel.numberOfLines = 0
            containerView.addSubview(descriptionLabel)
            
            containerView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.leading.equalTo(scrollView.snp.leading).offset(CGFloat(index) * UIScreen.main.bounds.width)
                make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(42)
                make.bottom.equalTo(pageControl.snp.top).offset(-16)
            }
            
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.bottom.equalTo(descriptionLabel.snp.top).offset(-24)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
        }
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = slides.count
        pageControl.pageIndicatorTintColor = UIColor.gray400.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .gray400
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(27)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-48)
        }
    }
    
    private func setupScrollViewContentSize() {
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(slides.count),
            height: scrollView.frame.height
        )
    }
    
    // MARK: - Actions
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let xOffset = CGFloat(sender.currentPage) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupScrollViewContentSize()
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage
    }
    
    var currentPage: Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.width)
    }

    var totalPages: Int {
        return slides.count
    }

    func scrollToPage(_ page: Int) {
        let xOffset = CGFloat(page) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
}
