//
//  MyPageWalkInfoView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import SnapKit
import UIKit

class MyPageWalkInfoView: UIView {

    private let titleFrame: UIView = {
        let view = UIView()
        return view
    }()

    private let walkInfoTitleLabel: MiddleTitleLabel = {
        let label = MiddleTitleLabel(text: "산책 관련 정보", textColor: .mainBlack)
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray200
        button.layer.cornerRadius = 4
        button.clipsToBounds = true

        let captionLabel = CaptionLabel(text: "수정하기", textColor: .gray400)
        captionLabel.textAlignment = .center
        button.addSubview(captionLabel)

        captionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()

    private let experienceTextLabel: SmallTitleLabel = {
        let label = SmallTitleLabel(text: "반려견 관련 경험", textColor: .gray600)
        return label
    }()

    private let experienceFrame: UIView = {
        let view = UIView()
        return view
    }()

    private let nurtureExperienceView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    private let nurtureExperienceTitleLabel: CaptionLabel = {
        let label = CaptionLabel(text: "양육 경험", textColor: .gray400)
        return label
    }()

    private let nurtureExperienceContentLabel: MainHighlightParagraphLabel = {
        let label = MainHighlightParagraphLabel(
            text: "없음", textColor: .mainBlue)
        return label
    }()

    private let nurtureExperienceBadgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let walkExperienceView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    private let walkExperienceTitleLabel: CaptionLabel = {
        let label = CaptionLabel(text: "산책 경험", textColor: .gray400)
        return label
    }()

    private let walkExperienceContentLabel: MainHighlightParagraphLabel = {
        let label = MainHighlightParagraphLabel(
            text: "첫걸음 산책자", textColor: .mainBlue)
        return label
    }()

    private let walkExperienceBadgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let serviceTextLabel: SmallTitleLabel = {
        let label = SmallTitleLabel(text: "제공 가능 서비스", textColor: .gray600)
        return label
    }()

    private let serviceFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    private let serviceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyPageCheckVerified")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let serviceFrameLabel: MainHighlightParagraphLabel = {
        let label = MainHighlightParagraphLabel(
            text: "소형견 / 중형견 산책 가능", textColor: .mainBlue)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        addSubview(titleFrame)
        titleFrame.addSubview(walkInfoTitleLabel)
        titleFrame.addSubview(editButton)

        addSubview(experienceTextLabel)
        addSubview(experienceFrame)
        nurtureExperienceView.addSubview(nurtureExperienceTitleLabel)
        nurtureExperienceView.addSubview(nurtureExperienceContentLabel)
        nurtureExperienceView.addSubview(nurtureExperienceBadgeImage)

        walkExperienceView.addSubview(walkExperienceTitleLabel)
        walkExperienceView.addSubview(walkExperienceContentLabel)
        walkExperienceView.addSubview(walkExperienceBadgeImage)

        experienceFrame.addSubview(nurtureExperienceView)
        experienceFrame.addSubview(walkExperienceView)

        addSubview(serviceTextLabel)
        addSubview(serviceFrame)
        let contentStack = UIStackView(arrangedSubviews: [
            serviceIcon, serviceFrameLabel,
        ])
        contentStack.axis = .horizontal
        contentStack.spacing = 4
        contentStack.alignment = .center

        serviceFrame.addSubview(contentStack)
    }

    private func setupConstraints() {
        titleFrame.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }

        walkInfoTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(25)
        }

        experienceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleFrame.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }

        experienceFrame.snp.makeConstraints { make in
            make.top.equalTo(experienceTextLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(157)
        }

        nurtureExperienceView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(experienceFrame.snp.width).multipliedBy(0.5).offset(-4)
        }

        walkExperienceView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(experienceFrame.snp.width).multipliedBy(0.5).offset(-4)
        }

        nurtureExperienceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }

        nurtureExperienceContentLabel.snp.makeConstraints { make in
            make.top.equalTo(nurtureExperienceTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }

        nurtureExperienceBadgeImage.snp.makeConstraints { make in
            make.top.equalTo(nurtureExperienceContentLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(80)
        }

        walkExperienceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }

        walkExperienceContentLabel.snp.makeConstraints { make in
            make.top.equalTo(walkExperienceTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }

        walkExperienceBadgeImage.snp.makeConstraints { make in
            make.top.equalTo(walkExperienceContentLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(80)
        }

        serviceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(experienceFrame.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }

        serviceFrame.snp.makeConstraints { make in
            make.top.equalTo(serviceTextLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(-29)
        }

        serviceIcon.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }

        if let contentStack = serviceFrame.subviews.first(where: { $0 is UIStackView }) as? UIStackView {
            contentStack.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}
