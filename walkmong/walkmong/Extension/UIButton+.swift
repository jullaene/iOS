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
    }
    
    static func createStyledButton(type: ButtonCategory, style: ButtonStyle, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 텍스트 폰트 설정
        let font: UIFont = {
            switch type {
            case .large, .homeFilter:
                return UIFont(name: "Pretendard-Bold", size: 16)!
            default:
                return UIFont(name: "Pretendard-SemiBold", size: 14)!
            }
        }()
        button.titleLabel?.font = font
        button.titleLabel?.textAlignment = .center
        
        // 배경색 및 텍스트 색상 설정
        switch type {
        case .large:
            button.layer.cornerRadius = 15
            button.backgroundColor = style == .light ? .gray300 : .gray600
            button.setTitleColor(style == .light ? .white : .gray100, for: .normal)
        case .largeSelection:
            button.layer.cornerRadius = 10
            button.backgroundColor = style == .light ? .gray100 : .mainBlue
            button.setTitleColor(style == .light ? .gray500 : .gray100, for: .normal)
        case .smallSelection:
            button.layer.cornerRadius = 10
            button.backgroundColor = style == .light ? .gray100 : .mainBlue
            button.setTitleColor(style == .light ? .gray500 : .white, for: .normal)
        case .homeFilter:
            button.layer.cornerRadius = 15
            button.backgroundColor = style == .light ? .gray100 : .gray600
            button.setTitleColor(style == .light ? .gray500 : .white, for: .normal)
        }
        
        // 텍스트 설정
        button.setTitle(title, for: .normal)
        
        // 크기 설정
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
            width = 73
            height = 38
        case .homeFilter:
            let textWidth: CGFloat = {
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                return (title as NSString).size(withAttributes: attributes).width
            }()
            width = textWidth + 32 // 좌우 패딩 16씩
            height = font.lineHeight + 16 // 상하 패딩 8씩
        }
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: width),
            button.heightAnchor.constraint(equalToConstant: height)
        ])
        
        return button
    }
}
