//
//  UILabel+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

extension UILabel {
    func setLineSpacing(ratio: Double) {
        
        self.lineBreakMode = .byWordWrapping
        self.lineBreakStrategy = .hangulWordPriority
        
        let style = NSMutableParagraphStyle()
        let lineheight = self.font.pointSize * ratio
        style.minimumLineHeight = lineheight
        style.maximumLineHeight = lineheight

        self.attributedText = NSAttributedString(
            string: self.text ?? "", attributes: [
            .paragraphStyle: style
          ])
    }
    
    func addCharacterSpacing(_ value: Double = -0.32) {
        let kernValue = self.font.pointSize * CGFloat(value)
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
