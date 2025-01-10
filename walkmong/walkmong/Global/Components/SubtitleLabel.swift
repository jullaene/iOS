//
//  SubtitleLabel.swift
//  walkmong
//
//  Created by 황채웅 on 12/31/24.
//

import Foundation
import UIKit
import SnapKit

class SubtitleLabel: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_subtitle")
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .mainBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(label)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.width.height.equalTo(12)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }

    func setContent(_ text: String, textColor: UIColor, image: UIImage) {
        label.text = text
        label.textColor = textColor
        imageView.image = image
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
