//
//  PetOwnerDetailReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class PetOwnerDetailReviewView: UIView {
    // MARK: - 서버 해시태그 매핑
    private let hashtags: [Hashtag] = Hashtag.allCases // enum Hashtag 사용

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
    
    let hashtagView: DetailReviewHashtagView

    let reviewPhotoView = ReviewPhotoView()

    private let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let submitButton: UIButton = {
        let button = UIButton.createStyledButton(type: .large, style: .dark, title: "완료")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.removeConstraints(button.constraints)
        return button
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        self.hashtagView = DetailReviewHashtagView(hashtags: Hashtag.allCases.map { $0.displayName })
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(scrollView)
        
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(infoContainerView, feedbackTitleLabel, hashtagSelectionLabel, hashtagView, reviewPhotoView)
        infoContainerView.addSubviews(walkerNameLabel, ratingLabel, ratingStarImageView, ratingValueLabel)
        addSubview(buttonView)
        buttonView.addSubview(submitButton)
        setupConstraints()
        self.layoutIfNeeded()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(52)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonView.snp.top)
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
        }
        
        reviewPhotoView.snp.makeConstraints { make in
            make.top.equalTo(hashtagView.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-34)
            make.height.equalTo(364)
        }
        
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(77)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(53)
        }
    }

    // MARK: - 해시태그 서버 포맷 변환
    func getServerFormattedHashtags() -> [String] {
        let selectedHashtags = hashtagView.getSelectedHashtags()
        return hashtags
            .filter { selectedHashtags.contains($0.displayName) }
            .map { $0.rawValue }
    }
}
