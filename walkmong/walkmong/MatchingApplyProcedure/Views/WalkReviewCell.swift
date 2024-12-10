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
    private let leftImageView = WalkReviewCell.createImageView()
    private let rightImageView = WalkReviewCell.createImageView()
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
        [profileFrame, circleStackView].forEach { roundedContainer.addSubview($0) }
    }

    func configure(with model: DogReviewModel) {
        profileFrame.configure(with: model.profileData)
        configureCircleStackView(with: model.circleTags)

        if !model.photos.isEmpty {
            configurePhotoFrame(with: model.photos)
            if photoFrame.superview == nil { roundedContainer.addSubview(photoFrame) }
        } else {
            photoFrame.removeFromSuperview()
        }

        if let reviewText = model.reviewText?.trimmingCharacters(in: .whitespacesAndNewlines), !reviewText.isEmpty {
            reviewTextLabel.text = reviewText
            if reviewTextLabel.superview == nil { roundedContainer.addSubview(reviewTextLabel) }
        } else {
            reviewTextLabel.removeFromSuperview()
        }

        setupDynamicConstraints()
    }

    private func configureCircleStackView(with tags: [(String, String)]) {
        circleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tags.forEach { title, tag in
            let circleView = CircleTagView(title: title, tag: tag)
            circleStackView.addArrangedSubview(circleView)
            circleView.snp.makeConstraints { $0.size.equalTo(96) }
        }
    }

    private func configurePhotoFrame(with photos: [UIImage]) {
        [leftImageView, rightImageView].forEach { $0.removeFromSuperview() }

        // 기본 이미지 설정
        let defaultImage = UIImage(named: "defaultImage") ?? UIImage(systemName: "photo") // 시스템 이미지를 대체로 사용 가능

        // 최대 2개의 이미지를 가져오되, 없으면 defaultImage로 대체
        let firstImage = photos.indices.contains(0) ? photos[0] : defaultImage
        let secondImage = photos.indices.contains(1) ? photos[1] : defaultImage

        // Left Image View 설정
        leftImageView.image = firstImage
        photoFrame.addSubview(leftImageView)
        leftImageView.snp.remakeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(leftImageView.snp.height).priority(.high)
        }

        // Right Image View 설정
        rightImageView.image = secondImage
        photoFrame.addSubview(rightImageView)
        rightImageView.snp.remakeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(leftImageView.snp.trailing).offset(8)
            $0.width.equalTo(rightImageView.snp.height).priority(.high)
        }

        // 한 개만 있을 경우 오른쪽 이미지 숨김 처리
        rightImageView.isHidden = photos.count < 2
    }
    
    // MARK: - Layout Constraints
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 24

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
    }
    
    private func setupDynamicConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 16

        if photoFrame.superview != nil {
            photoFrame.snp.remakeConstraints {
                $0.top.equalTo(circleStackView.snp.bottom).offset(spacing)
                $0.leading.trailing.equalToSuperview().inset(margin)
                $0.height.equalTo(photoFrame.snp.width).dividedBy(2)
            }
        }

        if reviewTextLabel.superview != nil {
            reviewTextLabel.snp.remakeConstraints {
                if photoFrame.superview != nil {
                    $0.top.equalTo(photoFrame.snp.bottom).offset(spacing)
                } else {
                    $0.top.equalTo(circleStackView.snp.bottom).offset(spacing)
                }
                $0.leading.trailing.equalToSuperview().inset(margin)
                $0.bottom.equalToSuperview().offset(-margin)
            }
        } else if photoFrame.superview != nil {
            photoFrame.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-margin)
            }
        } else {
            circleStackView.snp.makeConstraints {
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

    private static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }

    private static func createReviewTextLabel() -> MainParagraphLabel {
        let label = MainParagraphLabel(text: "", textColor: .gray600)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }
}
