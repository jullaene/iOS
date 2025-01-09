//
//  UIButton+.swift
//  walkmong
//
//  Created by 신호연 on 11/27/24.
//

import UIKit
import Kingfisher

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
        case tag
    }
    
    static func createStyledButton(
        type: ButtonCategory,
        style: ButtonStyle,
        title: String
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        switch type {
        case .customFilter:
            configureCustomFilter(button: button, style: style, title: title)
        case .homeFilter:
            if style == .profile {
                configureProfileStyle(button: button, style: style, title: title)
            } else {
                configureHomeFilter(button: button, style: style, title: title)
            }
        case .tag:
            configureTagButton(button: button, style: style, title: title)
        default:
            let label = labelForCategory(type: type, text: title, style: style)
            button.titleLabel?.font = label.font
            button.setTitleColor(label.textColor, for: .normal)
            configureStyle(for: button, type: type, style: style)
            button.setTitle(title, for: .normal)
        }
        
        configureStyle(for: button, type: type, style: style)
        
        if type == .smallSelection {
            let textWidth = calculateTextWidth(text: title, font: button.titleLabel!.font)
            let buttonWidth = textWidth + 32
            setButtonSizeConstraints(button: button, width: buttonWidth, height: 36)
        }
        
        return button
    }
    
    private static func buttonSizeForType(type: ButtonCategory, title: String, label: BaseTitleLabel) -> CGSize {
        switch type {
        case .smallSelection:
            let textWidth = calculateTextWidth(text: title, font: label.font)
            return CGSize(width: textWidth + 32, height: 36)
        case .homeFilter:
            let textWidth = calculateTextWidth(text: title, font: label.font)
            return CGSize(width: textWidth + 32, height: 36)
        default:
            return CGSize(width: label.frame.size.width, height: label.frame.size.height)
        }
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
        case .tag:
            return SmallMainHighlightParagraphLabel(text: text, textColor: textColor)
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
            button.backgroundColor = style == .dark ? .gray600 : .gray100
        case .customFilter:
            break
        case .tag:
            button.layer.cornerRadius = 15
            button.backgroundColor = style == .light ? .gray200 : .mainBlue
        }
    }
    
    static func configureCustomFilter(button: UIButton, style: ButtonStyle, title: String) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        
        let textColor: UIColor = style == .light ? .gray500 : .white
        let label = MainHighlightParagraphLabel(text: title, textColor: textColor)
        label.isUserInteractionEnabled = false
        
        let icon = UIImageView()
        icon.image = UIImage(named: style == .light ? "buttonArrowLight" : "buttonArrowDark")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = false
        
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
    
    private static func configureProfileStyle(button: UIButton, style: ButtonStyle, title: String) {
        let textColor: UIColor = style == .dark ? .white : .gray500
        let label = MainHighlightParagraphLabel(text: title, textColor: textColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8)
        ])
        
        button.layer.cornerRadius = 18
        button.backgroundColor = style == .light ? .gray200 : .gray600
    }
    
    private static func configureHomeFilter(button: UIButton, style: ButtonStyle, title: String) {
        button.subviews.forEach { subview in
            if subview is UILabel {
                subview.removeFromSuperview()
            }
        }
        
        let label = MainHighlightParagraphLabel(text: title, textColor: style == .light ? .gray500 : .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8)
        ])
        
        button.layer.cornerRadius = 18
        button.backgroundColor = style == .light ? .gray100 : .gray600
        
        if title.isEmpty {
            let icon = UIImage(named: "filterIcon")?.withRenderingMode(.alwaysTemplate)
            var configuration = UIButton.Configuration.plain()
            configuration.image = icon
            configuration.imagePlacement = .leading
            configuration.imagePadding = 8
            configuration.baseForegroundColor = UIColor(named: "gray500")
            button.configuration = configuration
        }
    }
    
    private static func configureTagButton(button: UIButton, style: ButtonStyle, title: String) {
        let textColor: UIColor = .mainBlack
        let backgroundColor: UIColor = style == .light ? .gray200 : .mainBlue
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.backgroundColor = backgroundColor
        
        let textWidth = calculateTextWidth(text: title, font: button.titleLabel!.font)
        let buttonWidth = textWidth + 18
        setButtonSizeConstraints(button: button, width: buttonWidth, height: 32)
        
        button.layer.cornerRadius = 15
    }
}
