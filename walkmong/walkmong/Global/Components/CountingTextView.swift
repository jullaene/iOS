//
//  CountingTextView.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import UIKit
import SnapKit

final class CountingTextView: UIView {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.textColor = .gray400
        textView.backgroundColor = .gray100
        textView.layer.cornerRadius = 5
        textView.textAlignment = .left
        textView.font = UIFont(name: "Pretendard-Regular", size: 16)
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private let countingLabel: UILabel = {
        let label = MainParagraphLabel(text: "(0/250)")
        label.textAlignment = .right
        return label
    }()
    
    private let maxCharacter: Int
    private let placeHolderText: String
    
    init(placeHolderText: String, maxCharacter: Int) {
        self.placeHolderText = placeHolderText
        self.maxCharacter = maxCharacter
        super.init(frame: .zero)
        setupView()
        setConstraints()
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(textView)
        self.addSubview(countingLabel)
        textView.delegate = self
        textView.text = placeHolderText
    }
    
    private func setConstraints() {
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        countingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func configureTextView() {
        textView.text = placeHolderText
        textView.textColor = .gray400
        applyTextAttributes()
        updateCountingLabel()
    }
    
    private func applyTextAttributes() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = (textView.font?.lineHeight ?? 0) * 0.4 // 행간 140%

        let attributedText = NSMutableAttributedString(
            string: textView.text,
            attributes: [
                .font: textView.font ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: textView.textColor ?? .gray400,
                .paragraphStyle: paragraphStyle,
                .kern: -0.32 // 자간 설정
            ]
        )

        textView.attributedText = attributedText
    }


    
    private func updateCountingLabel() {
        let currentCount = textView.text == placeHolderText ? 0 : textView.text.count
        let fullText = "(\(currentCount)/\(maxCharacter))"
        
        // NSMutableAttributedString 생성
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // 나머지 텍스트 스타일을 먼저 설정
        attributedText.addAttribute(.foregroundColor, value: UIColor.gray400, range: NSRange(location: 0, length: fullText.count))
        attributedText.addAttribute(.font, value: UIFont(name: "Pretendard-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: fullText.count))
        
        // 현재 카운트 부분만 스타일 변경
        if let currentCountRange = fullText.range(of: "\(currentCount)") {
            let nsRange = NSRange(currentCountRange, in: fullText)
            let currentColor: UIColor = currentCount == 0 ? .mainBlack : .mainBlue
            let currentFont: UIFont = currentCount == 0
                ? UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
                : UIFont(name: "Pretendard-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            
            attributedText.addAttribute(.foregroundColor, value: currentColor, range: nsRange)
            attributedText.addAttribute(.font, value: currentFont, range: nsRange)
        }
        
        // UILabel에 적용
        countingLabel.attributedText = attributedText
    }

    
    private func isPlaceholderActive() -> Bool {
        return textView.text == placeHolderText
    }
    
    func getString() -> String {
        return textView.text ?? ""
    }
}

extension CountingTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxCharacter {
            textView.text = String(textView.text.prefix(maxCharacter))
        }
        applyTextAttributes()
        updateCountingLabel()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive() {
            textView.text = ""
            textView.textColor = .gray500
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = .gray400
        }
        applyTextAttributes()
        updateCountingLabel()
    }
}
