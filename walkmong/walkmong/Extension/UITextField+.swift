//
//  UITextField+.swift
//  walkmong
//
//  Created by 황채웅 on 11/10/24.
//

import UIKit

extension UITextField {
    func addCharacterSpacing(_ value: Double = -0.32) {
        let kernValue = self.font!.pointSize * CGFloat(value)
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
