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

    init(title: String, tag: String) {
        super.init(frame: .zero)
        setupView()
        configureContent(title: title, tag: tag)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .mainBlue
        layer.cornerRadius = 48
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(28)
        }
        
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
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
