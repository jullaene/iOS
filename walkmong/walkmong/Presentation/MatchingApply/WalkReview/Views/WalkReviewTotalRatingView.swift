//
//  WalkReviewTotalRatingView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

class WalkReviewTotalRatingView: UIView {
    // MARK: - Subviews
    private let fixedFrameView = UIView()
    private let titleLabel = BaseTitleLabel(
        text: "총 평점",
        font: UIFont(name: "Pretendard-Bold", size: 16)!,
        textColor: .gray600
    )
    private let reviewStarIcon = UIImageView(image: UIImage(named: "reviewStarIcon"))
    private let ratingLabel = SmallTitleLabel(text: "0.0", textColor: .gray600)
    private let arrowIcon = UIImageView(image: UIImage(named: "reviewArrowIcon"))
    private let radarChartView = CustomRadarChartView()

    // MARK: - State
    private var isExpanded = false

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupTapGesture()
        updateViewState(animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .gray100
        layer.cornerRadius = 15
        clipsToBounds = true

        fixedFrameView.backgroundColor = .gray200
        fixedFrameView.layer.cornerRadius = 15
        fixedFrameView.clipsToBounds = true
        addSubview(fixedFrameView)

        radarChartView.clipsToBounds = true
        addSubview(radarChartView)

        [titleLabel, reviewStarIcon, ratingLabel, arrowIcon].forEach { fixedFrameView.addSubview($0) }

        arrowIcon.contentMode = .scaleAspectFit
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        fixedFrameView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        arrowIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowIcon.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        reviewStarIcon.snp.makeConstraints { make in
            make.trailing.equalTo(ratingLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        radarChartView.snp.makeConstraints { make in
            make.top.equalTo(fixedFrameView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20).priority(.high)
            make.height.equalTo(0)
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFixedFrameTap))
        fixedFrameView.addGestureRecognizer(tapGesture)
        fixedFrameView.isUserInteractionEnabled = true
    }

    // MARK: - Expand/Collapse Logic
    @objc private func handleFixedFrameTap() {
        isExpanded.toggle()
        updateViewState(animated: true)
    }

    private func updateViewState(animated: Bool) {
        self.arrowIcon.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity

        self.radarChartView.snp.updateConstraints { make in
            make.height.equalTo(self.isExpanded ? 244 : 0)
        }

        self.radarChartView.alpha = self.isExpanded ? 1 : 0

        self.snp.updateConstraints { make in
            make.height.equalTo(self.isExpanded ? 317 : 44)
        }

        self.superview?.layoutIfNeeded()
    }

    // MARK: - Configuration
    func configure(with rating: Double?) {
        ratingLabel.text = String(format: "%.1f", rating ?? 0.0)
    }
}
