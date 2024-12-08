//
//  WalkReviewCell.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class WalkReviewCell: UIView {

    // MARK: - Subviews
    private let roundedContainer = WalkReviewCell.createRoundedContainer()
    private let profileFrame = ProfileFrameView()
    private let circleStackView = WalkReviewCell.createCircleStackView()
    private let photoFrame = UIView()
    private let leftImageView = WalkReviewCell.createImageView()
    private let rightImageView = WalkReviewCell.createImageView()
    private let reviewTextLabel = WalkReviewCell.createReviewTextLabel()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        addSubview(roundedContainer)
        setupSubviews()
        setupConstraints()
        configureCircleStackView()
        configureImageViews()
    }

    private func setupSubviews() {
        [profileFrame, circleStackView, photoFrame, reviewTextLabel].forEach {
            roundedContainer.addSubview($0)
        }
        [leftImageView, rightImageView].forEach {
            photoFrame.addSubview($0)
        }
    }

    private func configureCircleStackView() {
        let circleItems = [
            ("사회성", "#낯가림 있어요"),
            ("활동량", "#활발해요"),
            ("공격성", "#안짖어요")
        ]

        circleItems.forEach { title, tag in
            let circleView = CircleTagView(title: title, tag: tag)
            circleStackView.addArrangedSubview(circleView)
            circleView.snp.makeConstraints { $0.size.equalTo(96) } // 크기 고정
        }
    }

    private func configureImageViews() {
        let defaultImage = UIImage(named: "defaultImage") ?? UIImage(systemName: "photo")
        [leftImageView, rightImageView].forEach { $0.image = defaultImage }
    }

    // MARK: - Layout Constraints
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 24
        let imageSpacing: CGFloat = 8

        roundedContainer.snp.makeConstraints { $0.edges.equalToSuperview() }

        profileFrame.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(50)
        }

        circleStackView.snp.makeConstraints {
            $0.top.equalTo(profileFrame.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(112)
        }

        photoFrame.snp.makeConstraints {
            $0.top.equalTo(circleStackView.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(photoFrame.snp.width).dividedBy(2).offset(-imageSpacing / 2)
        }

        leftImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(leftImageView.snp.height)
        }

        rightImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(leftImageView.snp.trailing).offset(imageSpacing)
            $0.width.equalTo(rightImageView.snp.height)
        }

        reviewTextLabel.snp.makeConstraints {
            $0.top.equalTo(photoFrame.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.bottom.equalToSuperview().offset(-margin)
        }
    }

    // MARK: - Factory Methods
    private static func createRoundedContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }

    private static func createCircleStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }

    private static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }

    private static func createReviewTextLabel() -> MainParagraphLabel {
        let label = MainParagraphLabel(
            text: "초코가 너무 귀여워서 산책하는 내내 행복했습니다. 주인분도 잘 설명해주시고 친절해서 좋았습니다.",
            textColor: .gray600
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
}
