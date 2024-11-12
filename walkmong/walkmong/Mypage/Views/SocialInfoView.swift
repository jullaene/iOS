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
    private struct Constants {
        static let frameWidth: CGFloat = 353
        static let cornerRadius: CGFloat = 5
        static let spacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 12
        static let titleFont = UIFont(name: "Pretendard-SemiBold", size: 12)!
        static let descriptionFont = UIFont(name: "Pretendard-SemiBold", size: 16)!
        static let headerFont = UIFont(name: "Pretendard-Bold", size: 20)!
        static let headerHeight: CGFloat = 28
        static let headerSpacing: CGFloat = 12
    }

    // MARK: - UI Components
    private lazy var headerLabel: UILabel = createHeaderLabel(text: "사회성 및 성향")
    private lazy var frames: [UIView] = [
        createFrame(title: "입질 여부", description: "우리 애는 진짜 안물어요."),
        createFrame(title: "친화력", description: "사람은 좋아하는데 다른 강아지 싫어해요."),
        createFrame(title: "짖음 여부", description: "거의 안짖어요.")
    ]

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
        frames.forEach { addSubview($0) }
    }

    private func setupLayout() {
        // Header Label Layout
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.headerHeight)
        }

        // Frames Layout
        for (index, frame) in frames.enumerated() {
            frame.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if index == 0 {
                    make.top.equalTo(headerLabel.snp.bottom).offset(Constants.headerSpacing)
                } else {
                    make.top.equalTo(frames[index - 1].snp.bottom).offset(Constants.spacing)
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func createHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                .kern: -0.32,
                .paragraphStyle: paragraphStyle
            ]
        )
        label.textColor = UIColor.gray600
        label.font = Constants.headerFont
        return label
    }

    private func createFrame(title: String, description: String) -> UIView {
        let frame = UIView()
        frame.backgroundColor = UIColor.gray100
        frame.layer.cornerRadius = Constants.cornerRadius

        let titleLabel = createLabel(
            text: title,
            font: Constants.titleFont,
            textColor: UIColor.gray400
        )
        let descriptionLabel = createLabel(
            text: description,
            font: Constants.descriptionFont,
            textColor: UIColor.mainBlue,
            numberOfLines: 0
        )

        frame.addSubview(titleLabel)
        frame.addSubview(descriptionLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.lessThanOrEqualToSuperview().offset(-Constants.horizontalPadding)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.lessThanOrEqualToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }

        return frame
    }

    private func createLabel(text: String, font: UIFont, textColor: UIColor, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
}
