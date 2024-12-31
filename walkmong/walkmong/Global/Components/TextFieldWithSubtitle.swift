//
//  TextFieldWithSubtitle.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import UIKit

class TextFieldWithSubtitle: UIStackView {
    
    private let subtitleLabel = SubtitleLabel()
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
    
    func setSubtitleText(textColor: UIColor, text: String, image: UIImage) {
        subtitleLabel.setContent(text, textColor: textColor, image: image)
    }
    
    func showSubtitleText(_ show: Bool) {
        subtitleLabel.isHidden = !show
    }
    
    func shakeSubtitleLabel() {
        subtitleLabel.shake()
    }

}
