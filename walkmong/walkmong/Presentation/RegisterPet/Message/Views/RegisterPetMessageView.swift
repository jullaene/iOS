//
//  RegisterPetMessageView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

protocol RegisterPetMessageViewDelegate: AnyObject {
    func didTapNextButton()
}

final class RegisterPetMessageView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private let titleLabel = MiddleTitleLabel(text: "산책자에게 전달할 메시지")
    
    private let requestLabel = SmallTitleLabel(text: "산책 요청 사항 (필수)")
    private let requestTextView = CountingTextView(placeHolderText: "산책하면서 지켜야 할 요청사항을 적어주세요.\n예) 산책하면서 간식을 주세요.\n산책 전에 드릴게요!", maxCharacter: 250)

    private let warningLabel = SmallTitleLabel(text: "산책 유의 사항 (필수)")
    private let warningTextView = CountingTextView(placeHolderText: "강아지가 특이 행동을 보일 수 있는 상황이나,\n대처방안에 대해 적어주세요.\n예) 다른 강아지를 만나면 엄청 짖어요.\n놀라지 마세요.", maxCharacter: 250)

    private let additionalInfoLabel = SmallTitleLabel(text: "추가 안내 사항 (선택)")
    private let additionalInfoTextView = CountingTextView(placeHolderText: "추가적으로 안내할 사항이 있다면 적어주세요.\n예) 사전 만남은 언제든 가능합니다!", maxCharacter: 250)

    private let nextButton = NextButton(text: "등록하기")
    
    weak var delegate: RegisterPetMessageViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraints()
        setUI()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        addSubviews(scrollView)
        scrollView.addSubviews(scrollContentView, nextButton)
        scrollContentView.addSubviews(titleLabel, requestLabel, requestTextView, warningLabel, warningTextView, additionalInfoLabel, additionalInfoTextView)

    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(additionalInfoTextView.snp.bottom).offset(144)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        requestLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        requestTextView.snp.makeConstraints { make in
            make.top.equalTo(requestLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(169)
        }
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(requestTextView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        warningTextView.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(169)
        }
        additionalInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(warningTextView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        additionalInfoTextView.snp.makeConstraints { make in
            make.top.equalTo(additionalInfoLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(169)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(46)
        }
    }
    
    private func setUI() {
        nextButton.setButtonState(isEnabled: true)
    }
    
    private func setButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        //TODO: 데이터 넘기는 로직 구현
        delegate?.didTapNextButton()
    }

}
