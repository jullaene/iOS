//
//  TextFieldWithSubtitle.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class TextFieldWithSubtitle: UIStackView {
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .mainBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let textField: TextField?
    
    init(frame: CGRect, textField: TextField) {
        super.init(frame: frame)
        self.textField = textField
        self.addSubviews(subtitleLabel, textField)
        self.spacing = 12
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension TextFieldWithSubtitle {
    
    func setSubtitleTextColor(color: UIColor) {
        subtitleLabel.textColor = color
    }
    
    func shakeSubtitleLabel() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 3
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: subtitleLabel.center.x - 5, y: subtitleLabel.center.y)
        let toPoint = CGPoint(x: subtitleLabel.center.x + 5, y: subtitleLabel.center.y)
        
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        subtitleLabel.layer.add(animation, forKey: "position")
    }

}
