//
//  MatchingDogInformationView.swift
//  walkmong
//
//  Created by 신호연 on 11/10/24.
//

import UIKit
import SnapKit

class MatchingDogInformationView: UIView, UIScrollViewDelegate {
    
    // MARK: - UI Components
    private let imageScrollView = UIScrollView()
    private let imageContentView = UIView() // 콘텐츠를 담을 컨테이너 뷰
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        
        // ScrollView 설정
        addSubview(imageScrollView)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageScrollView.snp.width).multipliedBy(297.66 / 393.0) // 비율 유지
        }
        
        // ScrollView 내부 콘텐츠 뷰 추가
        imageScrollView.addSubview(imageContentView)
        imageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // ScrollView 내부에서 꽉 차도록 설정
            make.height.equalToSuperview() // 세로 크기는 ScrollView와 동일
        }
        
        // PageControl 설정
        addSubview(pageControl)
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.mainBlue.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .mainBlue
        pageControl.backgroundColor = UIColor(red: 0.749, green: 0.749, blue: 0.749, alpha: 0.44)
        pageControl.layer.cornerRadius = 12
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(12.37)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
    // MARK: - Public Methods
    func configureImages(with imageNames: [String]) {
        // 기존 이미지 제거
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
        
        // 화면의 실제 너비 가져오기
        let screenWidth = UIScreen.main.bounds.width
        
        // 이미지 추가
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageContentView.addSubview(imageView)
            imageViews.append(imageView)
            
            // Auto Layout 설정
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(screenWidth) // 화면 너비에 맞추기
                make.height.equalTo(imageScrollView.snp.height) // ScrollView의 높이에 맞추기
                make.leading.equalToSuperview().offset(CGFloat(index) * screenWidth)
            }
        }
        
        // ScrollView Content Size 설정
        imageContentView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth * CGFloat(imageNames.count)) // 총 이미지 너비
        }
        
        // PageControl 설정
        pageControl.numberOfPages = imageNames.count
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
