//
//  DogProfileView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit
import Kingfisher

class DogProfileView: UIView, UIScrollViewDelegate {

    // MARK: - Constants
    private struct Constants {
        static let imageWidth: CGFloat = 353
        static let imageHeight: CGFloat = 267
        static let imageSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 20
        static let frameSpacing: CGFloat = 52
        static let bottomPadding: CGFloat = 40
        static let pageControlHeight: CGFloat = 24
    }

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        return view
    }()

    private let contentView = UIView()

    private let imageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.decelerationRate = .fast
        return view
    }()

    private let imageContentView = UIView()

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = UIColor.mainBlue.withAlphaComponent(0.3)
        control.currentPageIndicatorTintColor = .mainBlue
        control.backgroundColor = UIColor(white: 0.75, alpha: 0.44)
        control.layer.cornerRadius = 12
        return control
    }()

    private let basicInfoFrame = BasicInfoView()
    private let socialInfoFrame = SocialInfoView()
    private let vaccinationFrame = VaccinationView()

    private var imageViews: [UIView] = []

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addMultipleSubviews(imageScrollView, pageControl, basicInfoFrame, socialInfoFrame, vaccinationFrame)
        imageScrollView.addSubview(imageContentView)
        imageScrollView.delegate = self
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        imageScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 0.756)
        }

        // 이미지 중앙 정렬을 위한 contentInset 추가
        imageScrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: (UIScreen.main.bounds.width - Constants.imageWidth) / 2,
            bottom: 0,
            right: (UIScreen.main.bounds.width - Constants.imageWidth) / 2
        )

        imageContentView.snp.makeConstraints { $0.edges.height.equalToSuperview() }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.pageControlHeight)
        }

        basicInfoFrame.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(212)
        }

        socialInfoFrame.snp.makeConstraints {
            $0.top.equalTo(basicInfoFrame.snp.bottom).offset(Constants.frameSpacing)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        vaccinationFrame.snp.makeConstraints {
            $0.top.equalTo(socialInfoFrame.snp.bottom).offset(Constants.frameSpacing)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(86)
        }

        contentView.snp.makeConstraints {
            $0.bottom.equalTo(vaccinationFrame.snp.bottom).offset(Constants.bottomPadding)
        }
    }

    // MARK: - Public Methods
    func configure(with imageNames: [String]) {
        configureImages(imageNames)

        // 이미지가 하나일 경우 페이지 컨트롤 숨기고 basicInfoFrame 레이아웃 변경
        if imageNames.count <= 1 {
            pageControl.isHidden = true
            basicInfoFrame.snp.remakeConstraints {
                $0.top.equalTo(imageScrollView.snp.bottom).offset(32)
                $0.centerX.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(212)
            }
        } else {
            pageControl.isHidden = false
            basicInfoFrame.snp.remakeConstraints {
                $0.top.equalTo(pageControl.snp.bottom).offset(32)
                $0.centerX.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(212)
            }
        }
    }

    // MARK: - Private Methods
    private func configureImages(_ imageNames: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = imageNames.map { createImageView(urlString: $0) }

        for (index, imageView) in imageViews.enumerated() {
            imageContentView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(Constants.imageWidth)
                $0.leading.equalToSuperview().offset(CGFloat(index) * (Constants.imageWidth + Constants.imageSpacing))
            }
        }

        imageContentView.snp.makeConstraints {
            $0.width.equalTo((Constants.imageWidth + Constants.imageSpacing) * CGFloat(imageViews.count) - Constants.imageSpacing)
        }

        // 이미지가 하나일 경우
        if imageNames.count == 1 {
            let horizontalInset = (UIScreen.main.bounds.width - Constants.imageWidth) / 2
            imageScrollView.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
            imageScrollView.isScrollEnabled = false

            // 레이아웃 완료 후 contentOffset 고정
            DispatchQueue.main.async {
                self.imageScrollView.setContentOffset(CGPoint(x: -horizontalInset, y: 0), animated: false)
            }
        } else {
            // 여러 개의 이미지일 경우
            imageScrollView.contentInset = UIEdgeInsets(
                top: 0,
                left: (UIScreen.main.bounds.width - Constants.imageWidth) / 2,
                bottom: 0,
                right: (UIScreen.main.bounds.width - Constants.imageWidth) / 2
            )
            imageScrollView.isScrollEnabled = true
        }

        pageControl.numberOfPages = imageNames.count
        scrollToImage(at: 0)
    }

    private func scrollToImage(at index: Int) {
        guard (0..<imageViews.count).contains(index) else { return }
        let targetOffsetX = CGFloat(index) * (Constants.imageWidth + Constants.imageSpacing) - imageScrollView.contentInset.left
        imageScrollView.setContentOffset(CGPoint(x: max(0, targetOffsetX), y: 0), animated: true)
    }

    private func createImageView(urlString: String) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "defaultDogImage"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius

        view.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        return view
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Constants.imageWidth + Constants.imageSpacing
        let targetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let currentPage = round(targetX / pageWidth)
        
        let nearestPageOffsetX = currentPage * pageWidth - scrollView.contentInset.left
        targetContentOffset.pointee.x = nearestPageOffsetX
        pageControl.currentPage = Int(currentPage)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = Constants.imageWidth + Constants.imageSpacing
        let currentPage = round((scrollView.contentOffset.x + scrollView.contentInset.left) / pageWidth)
        pageControl.currentPage = Int(currentPage)
    }
}

// MARK: - Extensions
extension UIView {
    func addMultipleSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
