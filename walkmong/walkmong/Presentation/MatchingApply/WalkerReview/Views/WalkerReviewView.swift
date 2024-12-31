//
//  WalkerReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

final class WalkerReviewView: UIView {
    // MARK: - UI Elements
    private var navigationBarHeight: CGFloat = 52
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: LargeTitleLabel = {
        return LargeTitleLabel(text: "산책이 종료되었어요!")
    }()
    
    private let subtitleLabel: MainParagraphLabel = {
        return MainParagraphLabel(text: "봄별이와의 산책후기를 남겨주세요!")
    }()
    
    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Illustration2")
        return imageView
    }()
    
    private let reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.backgroundColor = .gray100
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private let bottomButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let detailedReviewButton: UIButton = {
        let button = UIButton.createStyledButton(type: .large, style: .light, title: "자세한 후기 작성하기")
        button.backgroundColor = .gray100
        button.setTitleColor(.gray400, for: .normal)
        return button
    }()
    
    let sendReviewButton: UIButton = {
        let button = UIButton.createStyledButton(type: .large, style: .light, title: "산책 후기 보내기")
        button.backgroundColor = .gray200
        button.setTitleColor(.gray400, for: .normal)
        return button
    }()
    
    // MARK: - Additional UI for reviewFeedbackView
    private let smallTitleLabel: SmallTitleLabel = {
        let label = SmallTitleLabel(text: "봄별이 반려인에 대해 어떻게\n생각하시나요?")
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 25.5
        button.setImage(UIImage(named: "reviewLikeIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 25.5
        button.setImage(rotatedImage(named: "reviewLikeIcon", rotationAngle: CGFloat.pi), for: .normal)
        button.addTarget(self, action: #selector(handleDislikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let likeDislikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - State
    private var isLikeSelected: Bool = false
    private var isDislikeSelected: Bool = false
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, subtitleLabel, illustrationImageView, reviewStackView)
        
        addSubview(bottomButtonView)
        bottomButtonView.addSubviews(detailedReviewButton, sendReviewButton)
        
        reviewStackView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        reviewStackView.isLayoutMarginsRelativeArrangement = true
        
        let reviewFeedbackView = UIView()
        reviewFeedbackView.backgroundColor = .white
        reviewFeedbackView.layer.cornerRadius = 20
        reviewFeedbackView.layer.masksToBounds = true
        
        reviewFeedbackView.addSubviews(smallTitleLabel, likeDislikeStackView)
        likeDislikeStackView.addArrangedSubview(dislikeButton)
        likeDislikeStackView.addArrangedSubview(likeButton)
        
        reviewFeedbackView.snp.makeConstraints { make in
            make.height.equalTo(159)
        }
        
        smallTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        likeDislikeStackView.snp.makeConstraints { make in
            make.top.equalTo(smallTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        dislikeButton.snp.makeConstraints { make in
            make.width.height.equalTo(51)
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(51)
        }
        
        let emptyView2 = UIView()
        emptyView2.backgroundColor = .white
        emptyView2.snp.makeConstraints { make in
            make.height.equalTo(572)
        }
        
        reviewStackView.addArrangedSubview(reviewFeedbackView)
        reviewStackView.addArrangedSubview(emptyView2)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(navigationBarHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomButtonView.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        illustrationImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.width.equalTo(254)
            make.height.equalTo(illustrationImageView.snp.width)
        }
        
        reviewStackView.snp.makeConstraints { make in
            make.top.equalTo(illustrationImageView.snp.bottom).offset(37)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(77)
        }
        
        detailedReviewButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(20)
        }
        
        sendReviewButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalTo(detailedReviewButton.snp.trailing).offset(9)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(detailedReviewButton)
        }
    }
    
    // MARK: - Button Actions
    @objc private func handleLikeButtonTapped() {
        isLikeSelected = true
        isDislikeSelected = false
        updateButtonStates()
        removeFeedbackViewIfNeeded()
    }
    
    @objc private func handleDislikeButtonTapped() {
        isDislikeSelected = true
        isLikeSelected = false
        updateButtonStates()
        addFeedbackViewIfNeeded()
    }
    
    private func updateButtonStates() {
        if isLikeSelected {
            likeButton.setImage(UIImage(named: "reviewLikeSelectedIcon"), for: .normal)
            likeButton.backgroundColor = .mainBlue
            
            dislikeButton.setImage(rotatedImage(named: "reviewLikeIcon", rotationAngle: CGFloat.pi), for: .normal)
            dislikeButton.backgroundColor = .gray100
        } else if isDislikeSelected {
            dislikeButton.setImage(rotatedImage(named: "reviewLikeSelectedIcon", rotationAngle: CGFloat.pi), for: .normal)
            dislikeButton.backgroundColor = .buttonBad
            
            likeButton.setImage(UIImage(named: "reviewLikeIcon"), for: .normal)
            likeButton.backgroundColor = .gray100
        }
    }
    
    private func addFeedbackViewIfNeeded() {
        if reviewStackView.arrangedSubviews.contains(where: { $0.tag == 1001 }) {
            return
        }
        
        let feedbackView = createFeedbackView()
        feedbackView.tag = 1001 // 고유 태그로 식별
        
        if reviewStackView.arrangedSubviews.count >= 2 {
            reviewStackView.insertArrangedSubview(feedbackView, at: 1)
        } else {
            reviewStackView.addArrangedSubview(feedbackView)
        }
        
        reviewStackView.setNeedsLayout()
        reviewStackView.layoutIfNeeded()
    }
    
    private func removeFeedbackViewIfNeeded() {
        if let feedbackView = reviewStackView.arrangedSubviews.first(where: { $0.tag == 1001 }) {
            reviewStackView.removeArrangedSubview(feedbackView)
            feedbackView.removeFromSuperview()
        }
    }
    
    private func createFeedbackView() -> UIView {
        let feedbackView = UIView()
        feedbackView.backgroundColor = .white
        feedbackView.layer.cornerRadius = 20

        feedbackView.snp.makeConstraints { make in
            make.height.equalTo(304)
        }

        let feedbackLabel = SmallTitleLabel(text: "봄별이 반려인이 어떤 점이 아쉬웠나요?")
        feedbackView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }

        let feedbackTextView = UITextView()
        feedbackTextView.backgroundColor = .gray100
        feedbackTextView.layer.cornerRadius = 5
        feedbackTextView.font = UIFont(name: "Pretendard-Medium", size: 16)
        feedbackTextView.textColor = .gray400
        feedbackTextView.text = "반려인과의 산책 과정 내에서 불편했거나, 힘들었던 점이 있었다면 적어주세요. 검토 후 반려인에게 패널티를 부과하겠습니다. (최소 20자 이상)"
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        feedbackTextView.delegate = self

        feedbackView.addSubview(feedbackTextView)
        feedbackTextView.snp.makeConstraints { make in
            make.top.equalTo(feedbackLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(224)
        }

        let charCountLabel = UILabel()
        charCountLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        charCountLabel.textColor = .gray500
        charCountLabel.text = "(0/250)"
        feedbackView.addSubview(charCountLabel)
        charCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(feedbackTextView.snp.trailing).offset(-12)
            make.bottom.equalTo(feedbackTextView.snp.bottom).offset(-12)
        }

        feedbackTextView.tag = 1002
        charCountLabel.accessibilityIdentifier = "charCountLabel"

        return feedbackView
    }
    
    private func rotatedImage(named imageName: String, rotationAngle: CGFloat) -> UIImage? {
        guard let originalImage = UIImage(named: imageName) else { return nil }
        UIGraphicsBeginImageContext(originalImage.size)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: originalImage.size.width / 2, y: originalImage.size.height / 2)
        context?.rotate(by: rotationAngle)
        originalImage.draw(in: CGRect(x: -originalImage.size.width / 2, y: -originalImage.size.height / 2, width: originalImage.size.width, height: originalImage.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}

// MARK: - UITextViewDelegate
extension WalkerReviewView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let feedbackView = textView.superview else {
            print("Error: textView.superview is nil")
            return
        }
        guard let charCountLabel = feedbackView.subviews.first(where: { $0.accessibilityIdentifier == "charCountLabel" }) as? UILabel else {
            print("Error: charCountLabel not found")
            return
        }

        CharacterCountManager.updateCountLabel(textView: textView, remainLabel: charCountLabel, button: nil)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "반려인과의 산책 과정 내에서 불편했거나, 힘들었던 점이 있었다면 적어주세요. 검토 후 반려인에게 패널티를 부과하겠습니다. (최소 20자 이상)" {
            textView.text = ""
            textView.textColor = .mainBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "반려인과의 산책 과정 내에서 불편했거나, 힘들었던 점이 있었다면 적어주세요. 검토 후 반려인에게 패널티를 부과하겠습니다. (최소 20자 이상)"
            textView.textColor = .gray400
        }
    }
}
