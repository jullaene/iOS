//
//  DogProfileView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class DogProfileView: UIView, UIScrollViewDelegate {

    // MARK: - UI Components
    private let imageScrollView = UIScrollView()
    private let imageContentView = UIView()
    private let pageControl = UIPageControl()
    private let nameLabel = UILabel()
    private let infoStackView = UIStackView()
    private var imageViews: [UIView] = []

    // MARK: - Constants
    private let imageWidth: CGFloat = 353
    private let imageHeight: CGFloat = 267
    private let imageSpacing: CGFloat = 8
    private let cornerRadius: CGFloat = 20

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white

        setupScrollView()
        setupPageControl()
        setupNameLabel()
        setupInfoStackView()
    }

    private func setupScrollView() {
        imageScrollView.isPagingEnabled = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageScrollView.clipsToBounds = false
        imageScrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: (UIScreen.main.bounds.width - imageWidth) / 2,
            bottom: 0,
            right: (UIScreen.main.bounds.width - imageWidth) / 2
        )
    }

    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .darkGray
    }

    private func setupNameLabel() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.text = "강아지 이름"
    }

    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 12
        infoStackView.distribution = .equalSpacing
        infoStackView.alignment = .leading

        ["성별: 남", "나이: 3살", "견종: 포메라니안", "몸무게: 4kg", "중성화 여부: O"].forEach {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .darkGray
            label.text = $0
            infoStackView.addArrangedSubview(label)
        }
    }

    private func setupLayout() {
        addSubview(imageScrollView)
        addSubview(pageControl)
        addSubview(nameLabel)
        addSubview(infoStackView)

        // Image ScrollView
        imageScrollView.addSubview(imageContentView)
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * 0.756)
        }

        imageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        // Page Control
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }

        // Name Label
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        // Info Stack View
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // MARK: - Public Methods
    func configureImages(with imageNames: [String]) {
        // 기존 이미지 뷰 제거
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = imageNames.map { createCustomImageView(named: $0) }

        // 새로운 이미지 추가
        for (index, imageView) in imageViews.enumerated() {
            imageContentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(imageWidth)
                make.leading.equalToSuperview().offset(CGFloat(index) * (imageWidth + imageSpacing))
            }
        }

        imageContentView.snp.makeConstraints { make in
            make.width.equalTo((imageWidth + imageSpacing) * CGFloat(imageViews.count) - imageSpacing)
        }

        pageControl.numberOfPages = imageNames.count
    }

    // MARK: - Helper Methods
    private func createCustomImageView(named imageName: String) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true

        return view
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = imageWidth + imageSpacing
        let targetX = scrollView.contentOffset.x + scrollView.contentInset.left
        let estimatedIndex = targetX / itemWidth

        // `velocity`를 기준으로 이동할 페이지 계산
        let velocityThreshold: CGFloat = 0.2
        let finalIndex: CGFloat
        if abs(velocity.x) > velocityThreshold {
            finalIndex = velocity.x > 0 ? ceil(estimatedIndex) : floor(estimatedIndex)
        } else {
            finalIndex = round(estimatedIndex)
        }

        let clampedIndex = max(0, min(finalIndex, CGFloat(imageViews.count - 1)))

        // 중앙 정렬로 스크롤 위치 설정
        let newOffsetX = clampedIndex * itemWidth - scrollView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: 0)

        pageControl.currentPage = Int(clampedIndex)
    }
}
