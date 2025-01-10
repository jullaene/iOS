//
//  CustomButtonView.swift
//  walkmong
//
//  Created by 신호연 on 1/11/25.
//

import UIKit
import SnapKit

final class CustomButtonView: UIView {
    
    // MARK: - Initializer
    init(
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        text: String,
        textColor: UIColor,
        iconName: String? = nil,
        iconSpacing: CGFloat = 8
    ) {
        super.init(frame: .zero)
        setupView(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            text: text,
            textColor: textColor,
            iconName: iconName,
            iconSpacing: iconSpacing
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView(
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        text: String,
        textColor: UIColor,
        iconName: String?,
        iconSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = iconSpacing
        stackView.addArrangedSubview(label)
        
        if let iconName = iconName, let iconImage = UIImage(named: iconName) {
            let icon = UIImageView(image: iconImage)
            icon.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(icon)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
