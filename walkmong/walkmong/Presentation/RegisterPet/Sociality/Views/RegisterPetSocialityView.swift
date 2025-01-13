//
//  RegisterPetSocialityView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit

protocol RegisterPetSocialityViewDelegate: AnyObject {
    func didTapNextButton()
}

final class RegisterPetSocialityView: UIView {
    
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
    
    private let titleLabel = MiddleTitleLabel(text: "반려견의 사회성 및 성향을\n알려주세요.")
    
    private let biteLabel = SmallTitleLabel(text: "입질 여부")
    private let biteTextView = CountingTextView(placeHolderText: "예) 입질 없이 얌전합니다", maxCharacter: 250)

    private let socialityLabel = SmallTitleLabel(text: "친화력")
    private let socialityTextView = CountingTextView(placeHolderText: "예) 처음에는 낯을 가리지만 금방 친해져요", maxCharacter: 250)

    private let barkLabel = SmallTitleLabel(text: "짖음 여부")
    private let barkTextView = CountingTextView(placeHolderText: "예) 낯선 소리에 짖는 편이에요", maxCharacter: 250)

    private let nextButton = NextButton(text: "다음으로")
    
    weak var delegate: RegisterPetSocialityViewDelegate?

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
        scrollContentView.addSubviews(titleLabel, biteLabel, biteTextView, socialityLabel, socialityTextView, barkLabel, barkTextView)

    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(barkTextView.snp.bottom).offset(144)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        biteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        biteTextView.snp.makeConstraints { make in
            make.top.equalTo(biteLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(129)
        }
        socialityLabel.snp.makeConstraints { make in
            make.top.equalTo(biteTextView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        socialityTextView.snp.makeConstraints { make in
            make.top.equalTo(socialityLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(129)
        }
        barkLabel.snp.makeConstraints { make in
            make.top.equalTo(socialityTextView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        barkTextView.snp.makeConstraints { make in
            make.top.equalTo(barkLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(129)
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
