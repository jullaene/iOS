//
//  WalkReviewTagView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

class WalkReviewTagView: UIView {
    private var tagLabels: [UILabel] = []
    private let spacing: CGFloat = 4

    private var heightConstraint: Constraint?

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTags()
    }

    func configure(with tags: [String]) {
        tagLabels.forEach { $0.removeFromSuperview() }
        tagLabels = []

        tags.forEach { tagText in
            let tagLabel = createTagLabel(with: tagText)
            tagLabels.append(tagLabel)
            addSubview(tagLabel)
        }
    }

    private func layoutTags() {
        guard !tagLabels.isEmpty else { return }

        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let maxWidth = bounds.width
        let tagHeight: CGFloat = 30

        for tagLabel in tagLabels {
            let tagSize = tagLabel.intrinsicContentSize
            let tagWidth = tagSize.width + 14 * 2

            if currentX + tagWidth > maxWidth {
                currentX = 0
                currentY += tagHeight + spacing
            }

            tagLabel.frame = CGRect(x: currentX, y: currentY, width: tagWidth, height: tagHeight)
            currentX += tagWidth + spacing
        }

        let totalHeight = currentY + tagHeight

        if let heightConstraint = self.heightConstraint {
            heightConstraint.deactivate()
            self.heightConstraint = nil
        }

        self.snp.makeConstraints { make in
            self.heightConstraint = make.height.equalTo(totalHeight).constraint
        }
    }

    private func createTagLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .gray600
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textAlignment = .center
        label.backgroundColor = .gray200
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }
}
