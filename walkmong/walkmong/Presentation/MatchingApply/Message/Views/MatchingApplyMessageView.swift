//
//  MatchingApplyMessageView.swift
//  walkmong
//
//  Created by 황채웅 on 11/14/24.
//

import UIKit

protocol MatchingApplyMessageViewDelegate: AnyObject {
    func didTapNextButton(message: String)
}

class MatchingApplyMessageView: UIView {
    
    weak var delegate: MatchingApplyMessageViewDelegate?
    private var characterCount = 0
        
    private let titleLabel = MiddleTitleLabel(text: "반려인에게 전달할 메세지")
    
    private let textViewPlaceHolder = "반려견의 보호자에게 전할 말이 있다면 작성해주세요."
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.textColor = .gray500
        textView.backgroundColor = .gray100
        textView.layer.cornerRadius = 5
        textView.text = textViewPlaceHolder
        textView.textAlignment = .left
        textView.font = UIFont(name: "Pretendard-Regular", size: 16)
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private lazy var remainCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textAlignment = .center
        label.textColor = .gray400
        let fullText = "(0/250)"
        let attributedString = NSMutableAttributedString(string: fullText)
        let countRange = (fullText as NSString).range(of: "0")
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: countRange)
        label.attributedText = attributedString
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 15
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        messageTextView.delegate = self
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        addSubviews(titleLabel, messageTextView, remainCountLabel, nextButton)
    }
    
    private func setConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(169)
        }
        remainCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(155)
            make.trailing.equalToSuperview().inset(32)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    @objc private func nextButtonTapped(){
        if characterCount > 0 {
            delegate?.didTapNextButton(message: messageTextView.text)
        }
    }
}

extension MatchingApplyMessageView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        characterCount = newString.count
        guard characterCount <= 250 else { return false }
        updateCount(characterCount: characterCount)
        return true
    }
    private func updateCount(characterCount: Int) {
        nextButton.backgroundColor = characterCount > 0 ? .gray600 : .gray300
        let fullText = "(\(characterCount)/250)"
        let attributedString = NSMutableAttributedString(string: fullText)
        let remainingRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray400, range: remainingRange)
        let countRange = (fullText as NSString).range(of: "\(characterCount)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainBlue, range: countRange)
        remainCountLabel.attributedText = attributedString
    }
}
