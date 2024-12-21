//
//  WalkReviewTagView.swift
//  walkmong
//
//  Created by 신호연 on 12/19/24.
//

import UIKit
import SnapKit

class WalkReviewTagView: UIView {
    // MARK: - Properties
    private var tagLabels: [UILabel] = []
    private let spacing: CGFloat = 4
    private var isExpanded: Bool = false
    private var tags: [String] = []
    private var heightConstraint: Constraint?

    // MARK: - Public Methods
    func configure(with tags: [String]) {
        self.tags = tags
        resetTags()
        updateTags()
    }

    // MARK: - Private Methods
    private func resetTags() {
        tagLabels.forEach { $0.removeFromSuperview() }
        tagLabels.removeAll()
    }

    private func updateTags() {
        let displayedTags = getDisplayedTags()
        
        displayedTags.forEach { tagText in
            let tagLabel = createTagLabel(with: tagText)
            tagLabels.append(tagLabel)
            addSubview(tagLabel)
            
            if tagText.starts(with: "+") {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandTags))
                tagLabel.addGestureRecognizer(tapGesture)
                tagLabel.isUserInteractionEnabled = true
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func getDisplayedTags() -> [String] {
        if isExpanded || tags.count <= 1 {
            return tags
        } else {
            return Array(tags.prefix(1)) + ["+\(tags.count - 1)"]
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
        label.sizeToFit()
        return label
    }

    @objc private func expandTags() {
        isExpanded = true
        resetTags()
        updateTags()
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTagLabels()
    }

    private func layoutTagLabels() {
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
        updateHeightConstraint(to: totalHeight)
    }

    private func updateHeightConstraint(to height: CGFloat) {
        heightConstraint?.deactivate()
        self.snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(height).constraint
        }
    }
}
