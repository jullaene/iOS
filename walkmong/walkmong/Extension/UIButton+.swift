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
        case rectangular
    }
    
    enum ButtonSize {
        case large
        case medium
        case small1
        case small2
    }
    
    static func createStyledButton(style: ButtonStyle, size: ButtonSize, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 배경색 설정
        switch style {
        case .light:
            button.backgroundColor = UIColor.gray100
            if size == .large {
                button.setTitleColor(.white, for: .normal)
            } else {
                button.setTitleColor(UIColor.gray400, for: .normal)
            }
        case .dark:
            button.backgroundColor = UIColor.gray600
            button.setTitleColor(UIColor.white, for: .normal)
        case .rectangular:
            button.backgroundColor = UIColor.mainBlue
            button.setTitleColor(UIColor.white, for: .normal)
        }
        
        // 텍스트 설정
        button.setTitle(title, for: .normal)
        let font: UIFont = {
            switch style {
            case .rectangular:
                return UIFont(name: "Pretendard-Bold", size: 16)!
            default:
                return UIFont(name: "Pretendard-SemiBold", size: 16)!
            }
        }()
        button.titleLabel?.font = font
        button.titleLabel?.textAlignment = .center
        
        // 텍스트 너비 계산
        let textWidth: CGFloat = {
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            return (title as NSString).size(withAttributes: attributes).width
        }()
        
        // 코너 반경 설정
        if size == .small2 {
            button.layer.cornerRadius = 18.5
        } else if style == .rectangular {
            button.layer.cornerRadius = 10
        } else {
            button.layer.cornerRadius = 15
        }
        
        // 크기 설정
        let width: CGFloat
        let height: CGFloat
        switch size {
        case .large:
            width = 363
            height = 54
        case .medium:
            width = 251
            height = 54
        case .small1:
            width = 93
            height = 53
        case .small2:
            width = textWidth + 32
            height = 38
        }
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: width),
            button.heightAnchor.constraint(equalToConstant: height)
        ])
        
        return button
    }
}
