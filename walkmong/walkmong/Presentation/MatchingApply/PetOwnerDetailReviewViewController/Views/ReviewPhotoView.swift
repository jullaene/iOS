//
//  ReviewPhotoView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class ReviewPhotoView: UIView {
    // MARK: - UI Elements
    private let detailedReviewLabel: SmallTitleLabel = {
        let label = SmallTitleLabel(text: "김철수님에 대한 자세한 후기를 남겨주세요.", textColor: .mainBlack)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let cameraContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray100.cgColor
        return view
    }()
    
    private let cameraIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cameraIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let photoCountLabel: BaseTitleLabel = {
        return BaseTitleLabel(
            text: "사진 0/2",
            font: UIFont(name: "Pretendard-Regular", size: 12)!,
            textColor: .gray600
        )
    }()
    
    lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.textColor = .gray500
        textView.backgroundColor = .gray100
        textView.layer.cornerRadius = 5
        textView.text = "작성한 산책 후기는 닉네임, 프로필 이미지와 함께 누구나 볼 수 있도록 공개됩니다. 내용에 민감한 개인정보가 포함되지 않도록 조심해주세요. (최소 20자 이상)"
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.textAlignment = .left
        return textView
    }()
    
    // 추가된 Rating Stack View
    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
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
        addSubviews(detailedReviewLabel, cameraContainerView, reviewTextView, ratingStackView)
        cameraContainerView.addSubviews(cameraIcon, photoCountLabel)
        setupConstraints()
        setupRatings()
    }

    private func setupConstraints() {
        detailedReviewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        cameraContainerView.snp.makeConstraints { make in
            make.top.equalTo(detailedReviewLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        cameraIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraIcon.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(cameraContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(224)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120) // 별점 뷰 높이 설정
        }
    }
    
    private func setupRatings() {
        let questions = [
            "시간 약속을 잘 지켰나요?",
            "산책자와의 소통이 원활했나요?",
            "배려심이 느껴졌나요?"
        ]
        
        for question in questions {
            let ratingView = RatingQuestionView(question: question)
            ratingStackView.addArrangedSubview(ratingView)
        }
    }
}
