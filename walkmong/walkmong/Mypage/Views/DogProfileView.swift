//
//  DogProfileView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class DogProfileView: UIView, UIScrollViewDelegate {

    // MARK: - Constants
    private struct Constants {
        static let imageWidth: CGFloat = 353
        static let imageHeight: CGFloat = 267
        static let imageSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 20
        static let frameWidth: CGFloat = 353
        static let frameSpacing: CGFloat = 52
        static let bottomPadding: CGFloat = 40
        static let pageControlHeight: CGFloat = 24
    }

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageScrollView = UIScrollView()
    private let imageContentView = UIView()
    private let pageControl = UIPageControl()
    
    private let basicInfoFrame = BasicInfoView()
    private let socialInfoFrame = SocialInfoView()
    private let vaccinationFrame = UIView()

    private var imageViews: [UIView] = []

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
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        setupScrollView()
        setupPageControl()
        setupFrames()
    }

    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        imageScrollView.showsHorizontalScrollIndicator = false // 스크롤바 숨기기
        imageScrollView.isPagingEnabled = false
        imageScrollView.decelerationRate = .fast
        imageScrollView.delegate = self

        // 중앙 정렬을 위해 좌우 여백 설정
        imageScrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: (UIScreen.main.bounds.width - Constants.imageWidth) / 2,
            bottom: 0,
            right: (UIScreen.main.bounds.width - Constants.imageWidth) / 2
        )
    }

    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.mainBlue.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .mainBlue
        pageControl.backgroundColor = UIColor(white: 0.75, alpha: 0.44)
        pageControl.layer.cornerRadius = 12
    }

    private func setupFrames() {
        basicInfoFrame.backgroundColor = .clear
        socialInfoFrame.backgroundColor = .clear
        vaccinationFrame.backgroundColor = .clear
    }

    // MARK: - Layout
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        contentView.addSubviews(imageScrollView, pageControl, basicInfoFrame, socialInfoFrame, vaccinationFrame)

        setupImageScrollViewLayout()
        setupPageControlLayout()
        setupFramesLayout()

        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(vaccinationFrame.snp.bottom).offset(Constants.bottomPadding)
        }
    }

    private func setupImageScrollViewLayout() {
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
    }

    private func setupPageControlLayout() {
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.pageControlHeight)
        }
    }

    private func setupFramesLayout() {
        basicInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.frameWidth)
            make.height.equalTo(212)
        }

        socialInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(basicInfoFrame.snp.bottom).offset(Constants.frameSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.frameWidth)
        }

        vaccinationFrame.snp.makeConstraints { make in
            make.top.equalTo(socialInfoFrame.snp.bottom).offset(Constants.frameSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.frameWidth)
            make.height.equalTo(86)
        }
    }

    // MARK: - Public Methods
    func configure(with imageNames: [String]) {
        configureImages(with: imageNames)
    }

    // MARK: - Private Methods
    private func configureImages(with imageNames: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = imageNames.map { createCustomImageView(named: $0) }

        for (index, imageView) in imageViews.enumerated() {
            imageContentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(Constants.imageWidth)
                make.leading.equalToSuperview().offset(CGFloat(index) * (Constants.imageWidth + Constants.imageSpacing))
            }
        }

        imageContentView.snp.makeConstraints { make in
            make.width.equalTo((Constants.imageWidth + Constants.imageSpacing) * CGFloat(imageViews.count) - Constants.imageSpacing)
        }

        pageControl.numberOfPages = imageNames.count

        scrollToImage(at: 0)
    }

    private func scrollToImage(at index: Int) {
        guard index >= 0, index < imageViews.count else { return }
        let targetOffsetX = CGFloat(index) * (Constants.imageWidth + Constants.imageSpacing) - imageScrollView.contentInset.left
        imageScrollView.setContentOffset(CGPoint(x: max(0, targetOffsetX), y: 0), animated: false)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = Constants.imageWidth + Constants.imageSpacing
        let targetX = scrollView.contentOffset.x + scrollView.contentInset.left
        let estimatedIndex = targetX / itemWidth

        let velocityThreshold: CGFloat = 0.2
        let finalIndex: CGFloat
        if abs(velocity.x) > velocityThreshold {
            finalIndex = velocity.x > 0 ? ceil(estimatedIndex) : floor(estimatedIndex)
        } else {
            finalIndex = round(estimatedIndex)
        }

        let clampedIndex = max(0, min(finalIndex, CGFloat(imageViews.count - 1)))
        let newOffsetX = clampedIndex * itemWidth - scrollView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: 0)

        pageControl.currentPage = Int(clampedIndex)
    }

    private func createCustomImageView(named imageName: String) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true

        return view
    }
}
