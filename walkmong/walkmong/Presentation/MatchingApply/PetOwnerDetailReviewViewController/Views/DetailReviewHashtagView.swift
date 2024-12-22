//
//  DetailReviewHashtagView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class DetailReviewHashtagView: UIView {
    private let buttonSpacing: CGFloat = 8
    private let rowSpacing: CGFloat = 16
    var hashtagButtons: [UIButton] = []

    init(hashtags: [String]) {
        super.init(frame: .zero)
        setupHashtagButtons(hashtags: hashtags)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHashtagButtons(hashtags: [String]) {
        for hashtag in hashtags {
            let button = UIButton.createStyledButton(type: .tag, style: .light, title: hashtag)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(toggleHashtagButtonStyle(_:)), for: .touchUpInside)
            hashtagButtons.append(button)
            addSubview(button)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutHashtagButtons()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        let totalHeight = hashtagButtons.last?.frame.maxY ?? 0
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    private func layoutHashtagButtons() {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let maxWidth = self.bounds.width

        for button in hashtagButtons {
            let buttonWidth = button.intrinsicContentSize.width + 16
            let buttonHeight = button.intrinsicContentSize.height

            if currentX + buttonWidth > maxWidth {
                currentX = 0
                currentY += buttonHeight + rowSpacing
            }

            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
            currentX += buttonWidth + buttonSpacing
        }
    }

    @objc private func toggleHashtagButtonStyle(_ sender: UIButton) {
        let isSelected = sender.backgroundColor == UIColor.mainBlue
        let newStyle: UIButton.ButtonStyle = isSelected ? .light : .dark
        
        sender.updateStyle(type: .tag, style: newStyle)
        
        if newStyle == .light {
            sender.setTitleColor(.mainBlack, for: .normal)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        return isInside
    }

    func getSelectedHashtags() -> [String] {
        return hashtagButtons
            .filter { $0.backgroundColor == UIColor.mainBlue }
            .compactMap { $0.title(for: .normal) }
    }
}
