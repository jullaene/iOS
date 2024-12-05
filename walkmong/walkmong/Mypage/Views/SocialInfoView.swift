//
//  SocialInfoView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class SocialInfoView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let frameWidth: CGFloat = 353
        static let spacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 12
        static let titleFont = UIFont(name: "Pretendard-SemiBold", size: 12)!
        static let descriptionFont = UIFont(name: "Pretendard-SemiBold", size: 16)!
        static let headerFont = UIFont(name: "Pretendard-Bold", size: 20)!
        static let headerHeight: CGFloat = 28
        static let headerSpacing: CGFloat = 12
        static let defaultDescription = "정보 없음"
    }

    // MARK: - UI Components
    private lazy var headerLabel: UILabel = createLabel(
        text: "사회성 및 성향",
        font: Constants.headerFont,
        textColor: .black
    )
    private var frames: [(container: UIView, descriptionLabel: UILabel)] = []

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
        backgroundColor = .clear
        addSubview(headerLabel)

        let framesData = [
            "입질 여부",
            "친화력",
            "짖음 여부"
        ]

        frames = framesData.map { createFrame(title: $0, description: Constants.defaultDescription) }
        frames.forEach { addSubview($0.container) }
    }

    private func setupLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.headerHeight)
        }

        for (index, frame) in frames.enumerated() {
            frame.container.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if index == 0 {
                    make.top.equalTo(headerLabel.snp.bottom).offset(Constants.headerSpacing)
                } else {
                    make.top.equalTo(frames[index - 1].container.snp.bottom).offset(Constants.spacing)
                }
            }
        }

        frames.last?.container.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.spacing)
        }
    }

    // MARK: - Public Methods
    func configure(bite: String?, friendly: String?, barking: String?) {
        let descriptions = [
            bite ?? Constants.defaultDescription,
            friendly ?? Constants.defaultDescription,
            barking ?? Constants.defaultDescription
        ]
        for (index, description) in descriptions.enumerated() {
            guard index < frames.count else { continue }
            frames[index].descriptionLabel.text = description
        }
    }

    // MARK: - Helper Methods
    private func createLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
    }

    private func createFrame(title: String, description: String) -> (container: UIView, descriptionLabel: UILabel) {
        let container = UIView()
        container.backgroundColor = .gray100
        container.layer.cornerRadius = 5

        let titleLabel = createLabel(text: title, font: Constants.titleFont, textColor: .darkGray)
        let descriptionLabel = createLabel(text: description, font: Constants.descriptionFont, textColor: .mainBlue)
        descriptionLabel.numberOfLines = 0

        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }

        return (container, descriptionLabel)
    }
}
