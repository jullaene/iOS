//
//  UIButton+.swift
//  walkmong
//
//  Created by 신호연 on 11/27/24.
//

import UIKit

extension UIButton {
    enum ButtonStyle {
        case light
        case dark
        case profile
    }
    
    enum ButtonCategory {
        case large
        case largeSelection
        case smallSelection
        case homeFilter
        case customFilter
    }
    
    static func createStyledButton(type: ButtonCategory, style: ButtonStyle, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if type == .customFilter {
            configureCustomFilter(button: button, style: style, title: title)
        } else {
            let label = labelForCategory(type: type, text: title, style: style)
            button.titleLabel?.font = label.font
            button.setTitleColor(label.textColor, for: .normal)
            configureStyle(for: button, type: type, style: style)
            button.setTitle(title, for: .normal)
            
            let width: CGFloat
            let height: CGFloat
            switch type {
            case .large:
                width = 363
                height = 54
            case .largeSelection:
                width = 361
                height = 46
            case .smallSelection:
                let textWidth = calculateTextWidth(text: title, font: label.font)
                width = textWidth + 32
                height = 36
            case .homeFilter, .customFilter:
                let textWidth = calculateTextWidth(text: title, font: label.font)
                width = textWidth + 32
                height = 36
            }
            setButtonSizeConstraints(button: button, width: width, height: height)

        }
        
        return button
    }
    
    private static func labelForCategory(type: ButtonCategory, text: String, style: ButtonStyle) -> BaseTitleLabel {
        let textColor: UIColor = style == .light
            ? (type == .large ? .white : .gray500)
            : (type == .large ? .gray100 : .white)
        
        switch type {
        case .large, .homeFilter, .customFilter:
            return MainHighlightParagraphLabel(text: text, textColor: textColor)
        case .largeSelection, .smallSelection:
            return MainParagraphLabel(text: text, textColor: textColor)
        }
    }
    
    private static func calculateTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return (text as NSString).size(withAttributes: attributes).width
    }
    
    private static func setButtonSizeConstraints(button: UIButton, width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: width),
            button.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private static func configureStyle(for button: UIButton, type: ButtonCategory, style: ButtonStyle) {
        switch type {
        case .large:
            button.layer.cornerRadius = 15
            button.backgroundColor = style == .light ? .gray300 : .gray600
        case .largeSelection:
            button.layer.cornerRadius = 5
            button.backgroundColor = style == .light ? .gray100 : .mainBlue
        case .smallSelection:
            button.layer.cornerRadius = 18
            button.backgroundColor = style == .light ? .gray100 : .mainBlue
        case .homeFilter:
            button.layer.cornerRadius = 18
            button.backgroundColor = style == .light ? .gray100 : .gray600
        case .customFilter:
            break
        }
    }
    
    static func configureCustomFilter(button: UIButton, style: ButtonStyle, title: String) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let textColor: UIColor = style == .light ? .gray500 : .white
        let label = MainHighlightParagraphLabel(text: title, textColor: textColor)
        
        let icon = UIImageView()
        icon.image = UIImage(named: style == .light ? "buttonArrowLight" : "buttonArrowDark")
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(icon)
        
        button.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        
        button.layer.cornerRadius = 18
        button.backgroundColor = style == .light ? .gray100 : .gray600
    }
    
    func updateStyle(type: ButtonCategory, style: ButtonStyle) {
        if type == .customFilter {
            UIButton.configureCustomFilter(button: self, style: style, title: self.title(for: .normal) ?? "")
        } else {
            let label = UIButton.labelForCategory(type: type, text: self.title(for: .normal) ?? "", style: style)
            self.titleLabel?.font = label.font
            self.setTitleColor(label.textColor, for: .normal)
            UIButton.configureStyle(for: self, type: type, style: style)
        }
    }
    
    func removeSizeConstraints() {
        self.constraints.forEach { constraint in
            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                self.removeConstraint(constraint)
            }
        }
    }
}
