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
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        [profileFrame, totalRatingView, circleTagView, photoFrame, reviewTextLabel, tagView].forEach {
            roundedContainer.addSubview($0)
        }
    }

    func configure(with model: DogReviewModel) {
        profileFrame.configure(with: model.profileData)

        if let totalRating = model.totalRating {
            totalRatingView.configure(with: totalRating)
            totalRatingView.isHidden = false
        } else {
            totalRatingView.isHidden = true
        }

        if let circleTags = model.circleTags, !circleTags.isEmpty {
            configureCircleTagView(with: circleTags)
            circleTagView.isHidden = false
        } else {
            circleTagView.isHidden = true
        }

        if let photos = model.photos, !photos.isEmpty {
            photoFrame.configure(with: photos)
            photoFrame.isHidden = false
        } else {
            photoFrame.isHidden = true
        }

        if let reviewText = model.reviewText?.trimmingCharacters(in: .whitespacesAndNewlines), !reviewText.isEmpty {
            reviewTextLabel.text = reviewText
            reviewTextLabel.isHidden = false
        } else {
            reviewTextLabel.isHidden = true
        }

        if let tags = model.tags, !tags.isEmpty {
            tagView.configure(with: tags)
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
        let spacing: CGFloat = 16

        roundedContainer.snp.makeConstraints { $0.edges.equalToSuperview() }

        profileFrame.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(44)
        }

        totalRatingView.snp.makeConstraints {
            $0.top.equalTo(profileFrame.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(margin)
        }
    }

    private func setupDynamicConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 16

        var lastView: UIView = totalRatingView

        [circleTagView, photoFrame, reviewTextLabel, tagView].forEach { subview in
            if subview.isHidden {
                subview.snp.removeConstraints()
            } else {
                subview.snp.remakeConstraints {
                    $0.top.equalTo(lastView.snp.bottom).offset(spacing)
                    $0.leading.trailing.equalToSuperview().inset(margin)

                    if subview === tagView {
                        $0.height.equalTo(tagView.snp.height)
                    }
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
