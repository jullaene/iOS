//
//  WalkReviewCell.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit
import SnapKit

class WalkReviewCell: UITableViewCell {

    // MARK: - Subviews
    private let roundedContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    private let profileFrame = ProfileFrameView()
    private let circleStackView = UIStackView()
    private let photoFrame = UIView()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
    private let reviewTextFrame = UIView()
    private let reviewTextLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(
            text: "초코가 너무 귀여워서 산책하는 내내 행복했습니다. 주인분도 잘 설명해주시고 친절해서 좋았습니다.",
            textColor: .gray600
        )
        label.numberOfLines = 0 // 줄바꿈 허용
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configureCell() {
        backgroundColor = .clear // 셀 배경 투명
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(roundedContainer)

        setupSubviews()
        setupConstraints()
        configureCircleStackView()
        configurePhotoFrame()
    }

    private func setupSubviews() {
        [profileFrame, circleStackView, photoFrame, reviewTextFrame].forEach {
            roundedContainer.addSubview($0)
        }
        [leftImageView, rightImageView].forEach {
            photoFrame.addSubview($0)
        }
        reviewTextFrame.addSubview(reviewTextLabel)

        // Configure Circle Stack View
        circleStackView.axis = .horizontal
        circleStackView.alignment = .center
        circleStackView.distribution = .equalSpacing
    }

    private func setupConstraints() {
        let margin: CGFloat = 20
        let imageSpacing: CGFloat = 8

        // Rounded container constraints
        roundedContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileFrame.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(50)
        }

        circleStackView.snp.makeConstraints { make in
            make.top.equalTo(profileFrame.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(112) // 고정 높이
        }

        photoFrame.snp.makeConstraints { make in
            make.top.equalTo(circleStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo((UIScreen.main.bounds.width - margin * 2 - imageSpacing) / 2) // 1:1 비율
        }

        leftImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(rightImageView.snp.leading).offset(-imageSpacing)
            make.width.equalTo(photoFrame.snp.height) // 1:1 비율
        }

        rightImageView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(photoFrame.snp.height) // 1:1 비율
        }

        reviewTextFrame.snp.makeConstraints { make in
            make.top.equalTo(photoFrame.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.bottom.equalToSuperview().offset(-20) // 마지막 제약
        }

        reviewTextLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 텍스트가 프레임에 맞게 확장
        }
    }

    private func configureCircleStackView() {
        let circleItems = [
            (title: "사회성", tag: "#낯가림 있어요"),
            (title: "활동량", tag: "#활발해요"),
            (title: "공격성", tag: "#안짖어요")
        ]

        circleItems.forEach { item in
            let circleView = CircleTagView(title: item.title, tag: item.tag)

            // 크기와 centerY 제약 조건 추가
            circleView.snp.makeConstraints { make in
                make.width.height.equalTo(96) // 원 크기 고정
            }
            circleStackView.addArrangedSubview(circleView)
        }
    }

    private func configurePhotoFrame() {
        let defaultImage = UIImage(named: "defaultImage")

        // Configure left image
        leftImageView.image = defaultImage
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        leftImageView.layer.cornerRadius = 5

        // Configure right image
        rightImageView.image = defaultImage
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.clipsToBounds = true
        rightImageView.layer.cornerRadius = 5
    }
}
