//
//  DetailReviewHashtagView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit

class HashtagView: UIView {
    private let buttonSpacing: CGFloat = 8
    private let rowSpacing: CGFloat = 16
    private var hashtagButtons: [UIButton] = []
    
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
            button.addTarget(self, action: #selector(toggleHashtagButtonStyle(_:)), for: .touchUpInside)
            hashtagButtons.append(button)
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutHashtagButtons()
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
        
        self.frame.size.height = currentY + (hashtagButtons.last?.intrinsicContentSize.height ?? 0)
    }
    
    @objc private func toggleHashtagButtonStyle(_ sender: UIButton) {
        let currentStyle: UIButton.ButtonStyle = sender.backgroundColor == UIColor.gray200 ? .dark : .light
        sender.updateStyle(type: .tag, style: currentStyle)
    }
}
