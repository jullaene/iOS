//
//  SubtitleLabel.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import Foundation
import UIKit

class SubtitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        self.font = UIFont(name: "Pretendard-Medium", size: 12)
        self.textColor = .mainBlue
        self.textAlignment = .left
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String, textColor: UIColor) {
        self.text = text
        self.textColor = textColor
    }
    
    func shake() {
        self.layer.removeAnimation(forKey: "shake")
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.075
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = -2
        animation.toValue = 2
        
        self.layer.add(animation, forKey: "shake")
    }
}
