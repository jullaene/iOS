//
//  CharacterCountManager.swift
//  walkmong
//
//  Created by 신호연 on 12/18/24.
//

import UIKit

class CharacterCountManager {
    static let maxCharacterCount = 250
    
    static func updateCountLabel(
        textView: UITextView,
        remainLabel: UILabel,
        button: UIButton
    ) {
        let characterCount = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count
        button.backgroundColor = characterCount > 0 ? .gray600 : .gray300
        
        let fullText = "(\(characterCount)/\(maxCharacterCount))"
        let attributedString = NSMutableAttributedString(string: fullText)
        let remainingRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray400, range: remainingRange)
        
        let countRange = (fullText as NSString).range(of: "\(characterCount)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: countRange)
        
        remainLabel.attributedText = attributedString
    }
}
