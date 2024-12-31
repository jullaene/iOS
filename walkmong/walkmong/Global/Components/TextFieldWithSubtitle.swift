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
    
    private var textField: TextField?
    
    init(textField: TextField) {
        super.init(frame: .zero)
        self.textField = textField
        self.addArrangedSubview(subtitleLabel)
        self.addArrangedSubview(textField)
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 12
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension TextFieldWithSubtitle {
    
    func setSubtitleText(textColor: UIColor, text: String) {
        subtitleLabel.textColor = textColor
        subtitleLabel.text = text
    }
    
    func showSubtitleText(_ show: Bool) {
        subtitleLabel.isHidden = !show
    }
    
    func shakeSubtitleLabel() {
        subtitleLabel.layer.removeAnimation(forKey: "shake")
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.075
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = -2
        animation.toValue = 2
        
        subtitleLabel.layer.add(animation, forKey: "shake")
    }

}
