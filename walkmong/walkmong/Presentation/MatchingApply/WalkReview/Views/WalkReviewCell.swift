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
    private let circleStackView = WalkReviewCell.createCircleStackView()
    private let photoFrame = UIView()
    private let reviewTextLabel = WalkReviewCell.createReviewTextLabel()

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
        [profileFrame, circleStackView, photoFrame, reviewTextLabel].forEach { roundedContainer.addSubview($0) }
    }

    func configure(with model: DogReviewModel) {
        profileFrame.configure(with: model.profileData)

        configureCircleStackView(with: model.circleTags)
        configurePhotoFrame(with: model.photos)
        
        if let reviewText = model.reviewText?.trimmingCharacters(in: .whitespacesAndNewlines), !reviewText.isEmpty {
            reviewTextLabel.text = reviewText
            reviewTextLabel.isHidden = false
        } else {
            reviewTextLabel.isHidden = true
        }

        setupDynamicConstraints()
    }

    private func configureCircleStackView(with tags: [(String, String)]) {
        circleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if tags.isEmpty {
            circleStackView.isHidden = true
        } else {
            circleStackView.isHidden = false
            tags.forEach { title, tag in
                let circleView = CircleTagView(title: title, tag: tag)
                circleStackView.addArrangedSubview(circleView)
                circleView.snp.makeConstraints { $0.size.equalTo(96) }
            }
        }
    }

    private func configurePhotoFrame(with photos: [UIImage]) {
        photoFrame.subviews.forEach { $0.removeFromSuperview() }

        if photos.isEmpty {
            photoFrame.isHidden = true
        } else {
            photoFrame.isHidden = false
            let defaultImage = UIImage(named: "defaultImage") ?? UIImage(systemName: "photo")
            let firstImage = photos.indices.contains(0) ? photos[0] : defaultImage
            let secondImage = photos.indices.contains(1) ? photos[1] : defaultImage

            let leftImageView = UIImageView(image: firstImage)
            let rightImageView = UIImageView(image: secondImage)

            photoFrame.addSubview(leftImageView)
            photoFrame.addSubview(rightImageView)

            leftImageView.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalTo(photoFrame.snp.width).multipliedBy(0.5).offset(-4)
            }

            rightImageView.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview()
                $0.leading.equalTo(leftImageView.snp.trailing).offset(8)
                $0.width.equalTo(photoFrame.snp.width).multipliedBy(0.5).offset(-4)
            }
        }
    }
    
    // MARK: - Layout Constraints
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 24

        roundedContainer.snp.makeConstraints { $0.edges.equalToSuperview() }

        profileFrame.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(44)
        }

        circleStackView.snp.makeConstraints {
            $0.top.equalTo(profileFrame.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(112)
        }
    }
    
    private func setupDynamicConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 16

        profileFrame.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(44)
        }

        if circleStackView.isHidden {
            circleStackView.snp.removeConstraints()
        } else {
            circleStackView.snp.remakeConstraints {
                $0.top.equalTo(profileFrame.snp.bottom).offset(spacing)
                $0.leading.trailing.equalToSuperview().inset(margin)
                $0.height.equalTo(112)
            }
        }

        if photoFrame.isHidden {
            photoFrame.snp.removeConstraints()
        } else {
            let topAnchor = circleStackView.isHidden ? profileFrame.snp.bottom : circleStackView.snp.bottom
            photoFrame.snp.remakeConstraints {
                $0.top.equalTo(topAnchor).offset(spacing)
                $0.leading.trailing.equalToSuperview().inset(margin)
                $0.height.equalTo(photoFrame.snp.width).dividedBy(2)
            }
        }

        if reviewTextLabel.isHidden {
            reviewTextLabel.snp.removeConstraints()
        } else {
            let topAnchor = photoFrame.isHidden
                ? (circleStackView.isHidden ? profileFrame.snp.bottom : circleStackView.snp.bottom)
                : photoFrame.snp.bottom
            reviewTextLabel.snp.remakeConstraints {
                $0.top.equalTo(topAnchor).offset(spacing)
                $0.leading.trailing.equalToSuperview().inset(margin)
                $0.bottom.equalToSuperview().offset(-margin)
            }
        }
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
