//
//  CountingTextView.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import Foundation
import UIKit

final class CountingTextView: UITextView {
    
    private let maxCharacter: Int
    private let countingLabel = MainParagraphLabel(text: "(0/250)")
    private var placeHolderText: String
    
    init(placeHolderText: String, maxCharacter: Int) {
        self.placeHolderText = placeHolderText
        self.maxCharacter = maxCharacter
        super.init(frame: .zero, textContainer: nil)
        self.textContainer.lineBreakMode = .byWordWrapping
        self.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.textColor = .gray400
        self.backgroundColor = .gray100
        self.layer.cornerRadius = 5
        self.text = placeHolderText
        self.textAlignment = .left
        self.font = UIFont(name: "Pretendard-Regular", size: 16)
        self.showsVerticalScrollIndicator = false
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview()
        setConstraints()
        updateCountingLabel()
    }
    
    private func addSubview() {
        self.addSubview(countingLabel)
    }
    
    private func setConstraints() {
        countingLabel.textAlignment = .right
        countingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func updateCountingLabel() {
        let currentCount = self.text == placeHolderText ? 0 : self.text.count
        countingLabel.text = "(\(currentCount)/\(maxCharacter))"
        countingLabel.textColor = currentCount == 0 ? .gray400 : .mainBlue
    }
    
    private func isPlaceholderActive() -> Bool {
        return self.text == placeHolderText
    }
}

extension CountingTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxCharacter {
            textView.text = String(textView.text.prefix(maxCharacter))
        }
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
        updateCountingLabel()
    }
}
