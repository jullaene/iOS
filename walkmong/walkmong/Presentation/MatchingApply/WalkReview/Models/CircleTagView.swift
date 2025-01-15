//
//  CircleTagView.swift
//  walkmong
//
//  Created by 신호연 on 12/7/24.
//

import UIKit

class CircleTagView: UIView {
    private let titleLabel = CaptionLabel(text: "", textColor: .white)
    private let tagLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .white)
    private let stackView = UIStackView()
    
    init(title: String, tag: String) {
        super.init(frame: .zero)
        setupView()
        configureContent(title: title, tag: tag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .mainBlue
        layer.cornerRadius = 48
        clipsToBounds = true

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(tagLabel)
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        snp.makeConstraints { make in
            make.width.height.equalTo(96)
        }
    }
    
    private func configureContent(title: String, tag: String) {
        titleLabel.text = title
        tagLabel.text = tag
    }
}
