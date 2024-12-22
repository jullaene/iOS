//
//  PetOwnerDetailReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class PetOwnerDetailReviewView: UIView {
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private let walkerNameLabel: SmallMainHighlightParagraphLabel = {
        return SmallMainHighlightParagraphLabel(text: "산책자 김철수님", textColor: .mainBlack)
    }()

    private let ratingLabel: LargeTitleLabel = {
        return LargeTitleLabel(text: "총 평점", textColor: .gray600)
    }()

    private let ratingStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reviewStarIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let ratingValueLabel: LargeTitleLabel = {
        return LargeTitleLabel(text: "5.0", textColor: .gray600)
    }()
    
    private let feedbackTitleLabel: LargeTitleLabel = {
        return LargeTitleLabel(text: "김철수님 어떤 점이 좋았나요?", textColor: .mainBlack)
    }()
    
    private let hashtagSelectionLabel: MainParagraphLabel = {
        return MainParagraphLabel(text: "해시태그를 최대 3가지 골라주세요", textColor: .mainBlack)
    }()
    
    private let hashtagView = DetailReviewHashtagView(hashtags: [
        "🐶 반려견이 좋아해요", "🤩 매너가 좋아요", "😊 꼼꼼해요", "🗓 일정 조정을 잘 해줘요",
        "🦮 산책을 성실히 해줘요", "👍 반려견을 잘 다뤄요", "💬 답장이 빨라요", "😉 요청 사항을 잘 들어줘요",
        "🎖 믿고 맡길 수 있어요", "😀 안전한 산책을 제공해요", "🧐 전문적으로 느껴져요"
    ])

    private let navigationBarHeight: CGFloat = 52

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
        
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(infoContainerView, feedbackTitleLabel, hashtagSelectionLabel, hashtagView)
        infoContainerView.addSubviews(walkerNameLabel, ratingLabel, ratingStarImageView, ratingValueLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(navigationBarHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        infoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(87)
        }
        
        walkerNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalTo(self.snp.centerX).offset(-2)
        }
        
        ratingStarImageView.snp.makeConstraints { make in
            make.leading.equalTo(ratingLabel.snp.trailing).offset(4)
            make.centerY.equalTo(ratingLabel)
            make.width.height.equalTo(20)
        }
        
        ratingValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(ratingStarImageView.snp.trailing).offset(4)
            make.centerY.equalTo(ratingLabel)
        }
        
        feedbackTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(infoContainerView.snp.bottom).offset(34)
        }
        
        hashtagSelectionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(feedbackTitleLabel)
            make.top.equalTo(feedbackTitleLabel.snp.bottom).offset(4)
        }
        
        hashtagView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(hashtagSelectionLabel)
            make.top.equalTo(hashtagSelectionLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-16)
            make.height.greaterThanOrEqualTo(1)
        }
    }
}
