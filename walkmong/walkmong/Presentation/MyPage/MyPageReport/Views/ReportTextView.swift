//
//  ReportTextView.swift
//  walkmong
//
//  Created by 신호연 on 12/17/24.
//

import UIKit

class ReportTextView: UITextView, UITextViewDelegate {
    var didChangeText: ((Int) -> Void)?
    
    let placeholderText = "신고 사유에 대해 하실 말씀이 있다면 자세히 말해주세요."
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        self.delegate = self
        self.backgroundColor = .gray100
        self.layer.cornerRadius = 5
        self.font = UIFont(name: "Pretendard-Medium", size: 16)
        self.textColor = .gray400
        self.text = placeholderText
        self.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 46, right: 12)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        didChangeText?(textView.text.count)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .gray500
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .gray400
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newLength = currentText.count + text.count - range.length
        return newLength <= 250
    }
}
