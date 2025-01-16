//
//  RelatedInfoView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

class RelatedInfoView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = createLabel(
        text: "산책 관련 정보",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-Bold", size: 20),
        lineHeightMultiple: 1.17,
        kern: -0.32
    )
    
    private let requestTitleLabel = createLabel(
        text: "산책 요청 사항",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-Bold", size: 16)
    )
    
    private let requestDescriptionLabel = createTextView(
        text: "",
        textColor: UIColor.gray500,
        font: UIFont(name: "Pretendard-Medium", size: 16)
    )
    
    private let referenceTitleLabel = createLabel(
        text: "산책 참고 사항",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-Bold", size: 16)
    )
    
    private let referenceDescriptionLabel = createTextView(
        text: "",
        textColor: UIColor.gray500,
        font: UIFont(name: "Pretendard-Medium", size: 16)
    )
    
    private let additionalInfoTitleLabel = createLabel(
        text: "추가 안내 사항",
        textColor: UIColor.gray600,
        font: UIFont(name: "Pretendard-Bold", size: 16)
    )
    
    private let additionalInfoDescriptionLabel = createTextView(
        text: "",
        textColor: UIColor.gray500,
        font: UIFont(name: "Pretendard-Medium", size: 16)
    )
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20
        
        let views: [UIView] = [
            titleLabel,
            requestTitleLabel,
            requestDescriptionLabel,
            referenceTitleLabel,
            referenceDescriptionLabel,
            additionalInfoTitleLabel,
            additionalInfoDescriptionLabel
        ]
        
        views.forEach { addSubview($0) }
        setupConstraints(views: views)
    }
    
    private func setupConstraints(views: [UIView]) {
        views[0].snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        
        views[1].snp.makeConstraints { make in
            make.top.equalTo(views[0].snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
        }
        
        for i in 2..<views.count {
            views[i].snp.makeConstraints { make in
                make.top.equalTo(views[i - 1].snp.bottom).offset(i % 2 == 0 ? 8 : 36)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
            }
        }
        
        views.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Public Methods
    func updateDetails(walkNote: String, walkRequest: String, additionalRequest: String) {
        requestDescriptionLabel.text = walkRequest
        referenceDescriptionLabel.text = walkNote
        additionalInfoDescriptionLabel.text = additionalRequest
    }
    
    // MARK: - Helper Methods
    private static func createLabel(
        text: String,
        textColor: UIColor,
        font: UIFont?,
        lineHeightMultiple: CGFloat = 1.0,
        kern: CGFloat = 0.0,
        numberOfLines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        return label
    }
    
    private static func createTextView(
        text: String,
        textColor: UIColor,
        font: UIFont?,
        lineHeightMultiple: CGFloat = 1.0,
        kern: CGFloat = 0.0
    ) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.textColor = textColor
        textView.font = font
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = .byCharWrapping

        let attributes: [NSAttributedString.Key: Any] = [
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        return textView
    }
}
