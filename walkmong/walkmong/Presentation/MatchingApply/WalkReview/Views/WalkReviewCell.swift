//
//  WalkReviewCell.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class WalkReviewCell: UIView {
    private let roundedContainer = WalkReviewCell.createRoundedContainer()
    private let profileFrame = ProfileFrameView()
    private let totalRatingView = WalkReviewTotalRatingView()
    private let circleTagView = WalkReviewCell.createCircleStackView()
    private let photoFrame = WalkReviewPhotoFrameView()
    private let reviewTextLabel = WalkReviewCell.createReviewTextLabel()
    private let tagView = WalkReviewTagView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        addSubview(roundedContainer)
        roundedContainer.addSubviews(profileFrame, totalRatingView, circleTagView, photoFrame, reviewTextLabel, tagView)
        setupConstraints()
    }
    
    func configure(with model: DogReviewModel) {
        profileFrame.configure(with: model.profileData)

        totalRatingView.configure(with: Double(model.totalRating))
        totalRatingView.isHidden = model.totalRating <= 0

        if let circleTags = model.circleTags, !circleTags.isEmpty {
            configureCircleTagView(with: circleTags)
            circleTagView.isHidden = false
        } else {
            circleTagView.isHidden = true
        }

        if !model.photos.isEmpty {
            let urls = model.photos.compactMap { $0 }
            photoFrame.configure(with: urls)
            photoFrame.isHidden = urls.isEmpty
        } else {
            photoFrame.isHidden = true
        }

        let trimmedReviewText = model.reviewText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedReviewText.isEmpty {
            reviewTextLabel.text = trimmedReviewText
            reviewTextLabel.isHidden = false
        } else {
            reviewTextLabel.isHidden = true
        }

        if !model.tags.isEmpty {
            tagView.configure(with: model.tags)
            tagView.isHidden = false
        } else {
            tagView.isHidden = true
        }

        setupDynamicConstraints()
    }

    private func configureCircleTagView(with tags: [(String, String)]) {
        circleTagView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if tags.isEmpty {
            circleTagView.isHidden = true
        } else {
            circleTagView.isHidden = false
            tags.forEach { title, tag in
                let circleView = CircleTagView(title: title, tag: tag)
                circleTagView.addArrangedSubview(circleView)
                circleView.snp.makeConstraints { $0.size.equalTo(96) }
            }
        }
    }

    private func setupConstraints() {
        let margin: CGFloat = 20

        roundedContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(100).priority(.medium)
        }

        profileFrame.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(44)
        }

    }

    private func setupDynamicConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 16

        var lastView: UIView = profileFrame

        [totalRatingView, circleTagView, photoFrame, reviewTextLabel, tagView].forEach { subview in
            if subview.isHidden {
                subview.snp.removeConstraints()
            } else {
                subview.snp.makeConstraints {
                    $0.top.equalTo(lastView.snp.bottom).offset(spacing)
                    $0.leading.trailing.equalToSuperview().inset(margin)
                }
                lastView = subview
            }
        }

        lastView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-margin)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

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

    private static func createReviewTextLabel() -> MainParagraphLabel {
        let label = MainParagraphLabel(text: "", textColor: .gray600)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }
}
