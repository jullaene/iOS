//
//  PetOwnerReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class PetOwnerReviewView: UIView {
    // MARK: - UI Elements
    private var navigationBarHeight: CGFloat = 52

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()

    private let titleLabel: LargeTitleLabel = {
        return LargeTitleLabel(text: "산책이 종료되었어요!")
    }()
    
    private let subtitleLabel: MainParagraphLabel = {
        return MainParagraphLabel(text: "김철수님의 산책후기를 남겨주세요!")
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
    
    var ratingQuestionView: UIStackView {
        return reviewStackView
    }
    
    private let bottomButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let detailedReviewButton: UIButton = {
        let button = UIButton.createStyledButton(type: .large, style: .light, title: "자세한 후기 작성하기")
        button.backgroundColor = .gray100
        button.setTitleColor(.gray400, for: .normal)
        button.addTarget(self, action: #selector(didTapDetailedReviewButton), for: .touchUpInside)
        return button
    }()
    
    let sendReviewButton: UIButton = {
        let button = UIButton.createStyledButton(type: .large, style: .light, title: "산책 후기 보내기")
        button.backgroundColor = .gray200
        button.setTitleColor(.gray400, for: .normal)
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureRadius()
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
        
        let questions = [
            "산책자가 시간 약속을 잘 지켰나요?",
            "산책자와의 소통이\n원활하게 이루어졌나요?",
            "산책자의 태도에 배려심이 느껴졌나요?",
            "산책자가 반려견 요청 사항을\n잘 수행했나요?",
            "산책자가 산책 중 사진을 보냈나요?"
        ]
        
        questions.forEach { question in
            let ratingView = RatingQuestionView(question: question)
            reviewStackView.addArrangedSubview(ratingView)
        }

        setupConstraints()

        DispatchQueue.main.async {
            self.configureRadius()
        }
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
    
    // MARK: - Configure Radius
    private func configureRadius() {
        let radiusPath = UIBezierPath(
            roundedRect: reviewStackView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = radiusPath.cgPath
        reviewStackView.layer.mask = maskLayer
    }
    
    // MARK: - Public Methods
    func setNavigationBarHeight(_ height: CGFloat) {
        self.navigationBarHeight = height
        scrollView.snp.updateConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(navigationBarHeight)
        }
        layoutIfNeeded()
    }
    
    func areAllRatingsFilled() -> Bool {
        return reviewStackView.arrangedSubviews
            .compactMap { $0 as? RatingQuestionView }
            .allSatisfy { $0.getSelectedRating() > 0 }
    }

    func updateButtonStates(isAllRated: Bool) {
        if isAllRated {
            detailedReviewButton.backgroundColor = .gray400
            detailedReviewButton.setTitleColor(.white, for: .normal)
            sendReviewButton.backgroundColor = .gray600
            sendReviewButton.setTitleColor(.white, for: .normal)
        } else {
            detailedReviewButton.backgroundColor = .gray100
            detailedReviewButton.setTitleColor(.gray400, for: .normal)
            sendReviewButton.backgroundColor = .gray200
            sendReviewButton.setTitleColor(.gray400, for: .normal)
        }
    }

    func collectRatings() -> [String: Float]? {
        let ratingTitles = [
            "timePunctuality",
            "communication",
            "attitude",
            "taskCompletion",
            "photoSharing"
        ]
        

        let ratings = reviewStackView.arrangedSubviews
            .compactMap { $0 as? RatingQuestionView }
            .enumerated()
            .reduce(into: [String: Float]()) { result, item in
                let (index, view) = item
                guard index < ratingTitles.count else { return }
                let rating = Float(view.getSelectedRating())
                if rating > 0 {
                    result[ratingTitles[index]] = rating
                }
            }
        
        return ratings.count == ratingTitles.count ? ratings : nil
    }

    func collectSelectedHashtags() -> [String] {
        return []
    }

    func collectImages() -> [String] {
        return []
    }

    func collectReviewContent() -> String? {
        return nil
    }
    
    @objc private func didTapDetailedReviewButton() {
        NotificationCenter.default.post(name: .ratingUpdated, object: nil)
    }
}
