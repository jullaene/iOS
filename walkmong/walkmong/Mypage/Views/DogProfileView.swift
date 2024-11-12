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

        // Image ScrollView 설정
        imageScrollView.isPagingEnabled = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        imageScrollView.clipsToBounds = false
        imageScrollView.contentInset = UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 353) / 2, bottom: 0, right: (UIScreen.main.bounds.width - 353) / 2)

        // Page Control 설정
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .darkGray

        // Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.text = "강아지 이름"

        // Info Stack View
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
            make.height.equalTo(imageScrollView.snp.width).multipliedBy(267.0 / 353.0)
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
                make.width.equalTo(353)
                make.height.equalTo(267)
                make.leading.equalToSuperview().offset(CGFloat(index) * (353 + 8))
            }
        }

        imageContentView.snp.makeConstraints { make in
            make.width.equalTo((353 + 8) * CGFloat(imageNames.count) - 8)
        }

        pageControl.numberOfPages = imageNames.count
    }

    // MARK: - Helper Methods
    private func createCustomImageView(named imageName: String) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 353, height: 267)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "defaultDogImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.layer.cornerRadius = 20
        view.clipsToBounds = true

        return view
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = CGFloat(353 + 8) // 이미지와 간격 포함한 너비
        let targetX = scrollView.contentOffset.x + scrollView.contentInset.left
        let estimatedIndex = targetX / itemWidth // 드래그로 예상되는 페이지

        // `velocity`를 기준으로 이동할 페이지 계산
        let velocityThreshold: CGFloat = 0.2 // 민감도 조정
        let finalIndex: CGFloat
        if abs(velocity.x) > velocityThreshold {
            // 빠르게 드래그했을 때 더 멀리 넘기기
            finalIndex = velocity.x > 0 ? ceil(estimatedIndex) : floor(estimatedIndex)
        } else {
            // 천천히 드래그했을 때 가까운 페이지로 정렬
            finalIndex = round(estimatedIndex)
        }

        // 페이지 범위를 초과하지 않도록 제한
        let clampedIndex = max(0, min(finalIndex, CGFloat(imageViews.count - 1)))

        // 중앙 정렬로 스크롤 위치 설정
        let newOffsetX = clampedIndex * itemWidth - scrollView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: 0)

        // 현재 페이지 업데이트
        pageControl.currentPage = Int(clampedIndex)
    }
}
