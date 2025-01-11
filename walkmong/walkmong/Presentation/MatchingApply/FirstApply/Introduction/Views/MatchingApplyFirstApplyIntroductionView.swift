//
//  MatchingApplyFirstIntroductionView.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

protocol MatchingApplyFirstIntroductionViewDelegate: AnyObject {
    func didTapNextButton(_ message: String)
}

final class MatchingApplyFirstIntroductionView: UIView {
    
    private let titleLabel = MiddleTitleLabel(text: "본인을 소개하는 글을 작성해주세요.")
    
    private let textView = CountingTextView(placeHolderText: "본인의 성향, 반려동물을 사랑하는 마음 등을 간단히 적어주세요. 상대방이 신뢰할 수 있는 소개가 좋아요! (최소 20자 이상)", maxCharacter: 250)
    
    private let nextButton = NextButton(text: "저장하기")
    
    weak var delegate: MatchingApplyFirstIntroductionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setButtonAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(titleLabel, textView, nextButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(169)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    private func setButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        if textView.text.count >= 20 {
            delegate?.didTapNextButton(textView.text)
        }
    }
    
}

