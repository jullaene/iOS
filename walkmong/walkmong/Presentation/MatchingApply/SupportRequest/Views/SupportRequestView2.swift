//
//  SupportRequestView2.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class SupportRequestView2: UIView {
    
    // MARK: - Properties
    private let smallTitle = SmallTitleLabel(text: "산책 날짜를 선택해주세요.")
    private let warningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "warningIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let warningText = SmallMainHighlightParagraphLabel(text: "오늘부터 2주 이내의 날짜를 선택하실 수 있어요.", textColor: .gray400)

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews(smallTitle, warningIcon, warningText)
        setupConstraints()
    }
    
    private func setupConstraints() {
        smallTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        warningIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(warningText.snp.centerY)
        }
        
        warningText.snp.makeConstraints { make in
            make.top.equalTo(smallTitle.snp.bottom).offset(5)
            make.leading.equalTo(warningIcon.snp.trailing).offset(4)
        }
    }
}
