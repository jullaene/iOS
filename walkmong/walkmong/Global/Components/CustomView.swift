//
//  CustomView.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import UIKit
import SnapKit

class CustomView: UIView {
    static func createCustomView(
        titleText: String?,
        warningText: String? = nil,
        warningColor: UIColor? = nil,
        centerLabelText: String? = nil,
        contentText: String? = nil,
        contentTextColor: UIColor = .gray600,
        contentTextAlignment: NSTextAlignment = .left,
        layoutOption: LayoutOption = .default
    ) -> UIView {
        let containerView = UIView()
        var lastView: UIView = containerView

        if let titleText = titleText {
            let titleLabel = SmallTitleLabel(text: titleText, textColor: .gray600)
            containerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
            lastView = titleLabel
        }

        if let warningText = warningText, let warningColor = warningColor {
            let warningIcon = UIImage.createImageView(
                named: "WarningIconMainBlue",
                contentMode: .scaleAspectFit
            )
            warningIcon.tintColor = warningColor
            containerView.addSubview(warningIcon)

            let warningLabel = SmallMainHighlightParagraphLabel(text: warningText, textColor: warningColor)
            containerView.addSubview(warningLabel)

            warningIcon.snp.makeConstraints { make in
                make.top.equalTo(lastView.snp.bottom).offset(8)
                make.leading.equalToSuperview()
            }

            warningLabel.snp.makeConstraints { make in
                make.centerY.equalTo(warningIcon.snp.centerY)
                make.leading.equalTo(warningIcon.snp.trailing).offset(4)
                make.trailing.equalToSuperview()
            }

            lastView = warningLabel
        }

        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.layer.cornerRadius = 5
        whiteBackgroundView.clipsToBounds = true
        containerView.addSubview(whiteBackgroundView)
        whiteBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(lastView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        switch layoutOption {
        case .default:
            if let centerLabelText = centerLabelText {
                let centerLabel = MainHighlightParagraphLabel(text: centerLabelText, textColor: .gray600)
                whiteBackgroundView.addSubview(centerLabel)
                centerLabel.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            } else if let contentText = contentText {
                let contentLabel = MainParagraphLabel(text: contentText, textColor: contentTextColor)
                contentLabel.numberOfLines = 0
                contentLabel.lineBreakMode = .byWordWrapping
                contentLabel.textAlignment = contentTextAlignment
                whiteBackgroundView.addSubview(contentLabel)
                contentLabel.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview().inset(12)
                    make.leading.trailing.equalToSuperview().inset(16)
                }
            }
        case .leftAlignedContent:
            if let contentText = contentText {
                let contentLabel = MainParagraphLabel(text: contentText, textColor: contentTextColor)
                contentLabel.numberOfLines = 0
                contentLabel.lineBreakMode = .byWordWrapping
                contentLabel.textAlignment = .left
                whiteBackgroundView.addSubview(contentLabel)
                contentLabel.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(12)
                }
            }
        case .centerAndLeftAligned:
            if let centerLabelText = centerLabelText {
                let centerLabel = MainHighlightParagraphLabel(text: centerLabelText, textColor: .gray600)
                whiteBackgroundView.addSubview(centerLabel)
                centerLabel.snp.makeConstraints { make in
                    make.top.leading.trailing.equalToSuperview().inset(12)
                }

                if let contentText = contentText {
                    let contentLabel = MainParagraphLabel(text: contentText, textColor: contentTextColor)
                    contentLabel.numberOfLines = 0
                    contentLabel.lineBreakMode = .byWordWrapping
                    contentLabel.textAlignment = contentTextAlignment
                    whiteBackgroundView.addSubview(contentLabel)
                    contentLabel.snp.makeConstraints { make in
                        make.top.equalTo(centerLabel.snp.bottom).offset(10)
                        make.leading.trailing.bottom.equalToSuperview().inset(12)
                    }
                }
            }
        }

        return containerView
    }

    enum LayoutOption {
        case `default`
        case leftAlignedContent
        case centerAndLeftAligned
    }
}
