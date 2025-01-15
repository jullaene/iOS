//
//  MatchingApplyWalkRequestTextInputView.swift
//  walkmong
//
//  Created by 신호연 on 1/5/25.
//

import UIKit
import SnapKit

final class MatchingApplyWalkRequestTextInputView: UIView {
    // MARK: - Properties
    private var iconStates: [Bool] = [false, false, false]
    private var textViewStates: [Bool] = Array(repeating: false, count: 3)
    private var isInitialState: Bool = true
    private var iconImageViews: [UIImageView] = []
    private var saveLabels: [UILabel] = []
    private var texts: [String] = Array(repeating: "", count: 3)
    
    var textViewDidUpdate: ((Bool, [String]) -> Void)?
    
    private let titles = [
        "산책 요청 사항 (필수)",
        "산책 유의 사항 (필수)",
        "추가 안내 사항 (선택)"
    ]
    
    private let placeholders = [
        "강아지를 산책하면서 산책자에게 부탁하고 싶은 사항을 적어주세요.\n예) 리드줄을 세게 당기지 말아주세요.",
        "강아지가 특이 행동을 보일 수 있는 상황이나, 대처방안에 대해 적어주세요.\n예) 다른 강아지를 만나면 엄청 짖어요. 놀라지 마세요.",
        ""
    ]
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        var lastView: UIView? = nil
        
        for (index, title) in titles.enumerated() {
            let titleLabel = createTitleLabel(text: title)
            let containerView = createContainerView(placeholder: placeholders[index], index: index)
            
            addSubviews(titleLabel, containerView)
            
            titleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if let lastView = lastView {
                    make.top.equalTo(lastView.snp.bottom).offset(48)
                } else {
                    make.top.equalToSuperview().offset(16)
                }
            }
            
            containerView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(169)
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                if index == titles.count - 1 {
                    make.bottom.equalToSuperview().inset(29)
                }
            }
            
            lastView = containerView
        }
    }
    
    private func setupGesture() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDownGesture.direction = .down
        addGestureRecognizer(swipeDownGesture)
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUpGesture.direction = .up
        addGestureRecognizer(swipeUpGesture)
    }
    
    private func createTitleLabel(text: String) -> UILabel {
        let titleLabel = SmallTitleLabel(text: text, textColor: .gray600)
        return titleLabel
    }
    
    private func createContainerView(placeholder: String, index: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .gray100
        containerView.layer.cornerRadius = 5
        
        let textView = UITextView()
        textView.tag = index
        textView.text = placeholder
        textView.textColor = .gray400
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 9.5, left: 12, bottom: 9.5, right: 12)
        textView.isScrollEnabled = true
        textView.delegate = self
        textView.backgroundColor = .clear
        
        containerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(104)
        }
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(named: "check444444"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageViews.append(iconImageView)
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(9.5)
        }
        
        let saveLabel = SmallMainHighlightParagraphLabel(text: "작성한 내용 저장", textColor: .gray500)
        saveLabels.append(saveLabel)
        containerView.addSubview(saveLabel)
        saveLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(4)
            make.centerY.equalTo(iconImageView)
        }
        saveLabel.isUserInteractionEnabled = true
        
        let saveTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveTapped(_:)))
        saveLabel.addGestureRecognizer(saveTapGesture)
        saveLabel.tag = index
        
        let countLabel = MainParagraphLabel(text: "(0/250)", textColor: .gray600)
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(9.5)
        }
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func saveTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        iconStates[index].toggle()
        
        let iconImage = iconStates[index] ? "myPageReportChecked" : "check444444"
        iconImageViews[index].image = UIImage(named: iconImage)
    }
    
    @objc private func handleSwipe() {
        endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension MatchingApplyWalkRequestTextInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let index = textView.tag
        guard texts.indices.contains(index), textViewStates.indices.contains(index) else { return }
        
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        textViewStates[index] = !text.isEmpty
        texts[index] = text
        checkIfAllRequiredFieldsAreFilled()
        
        if let countLabel = textView.superview?.subviews.compactMap({ $0 as? UILabel }).last {
            CharacterCountManager.updateCountLabel(textView: textView, remainLabel: countLabel)
        }
    }

    private func checkIfAllRequiredFieldsAreFilled() {
        let allRequiredFieldsFilled = textViewStates.prefix(2).allSatisfy { $0 }
        textViewDidUpdate?(allRequiredFieldsFilled, texts)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray400 {
            textView.text = ""
            textView.textColor = .gray600
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            guard let index = iconImageViews.firstIndex(where: { $0.superview?.subviews.contains(textView) == true }) else { return }
            textView.text = placeholders[index]
            textView.textColor = .gray400
        }
    }
}
