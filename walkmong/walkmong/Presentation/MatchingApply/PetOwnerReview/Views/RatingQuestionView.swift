//
//  RatingQuestionView.swift
//  walkmong
//
//  Created by 신호연 on 12/22/24.
//

import UIKit
import SnapKit

class RatingQuestionView: UIView {
    // MARK: - Properties
    private let questionLabel: SmallTitleLabel
    private var stars: [UIImageView] = []
    private var lastGeneratedRating: Int = 0

    private var selectedRating: Int = 0 {
        didSet {
            updateStarImages()
            provideHapticFeedback()
        }
    }
    
    // MARK: - Initializer
    init(question: String) {
        self.questionLabel = SmallTitleLabel(text: question)
        self.questionLabel.textAlignment = .center
        self.questionLabel.numberOfLines = 0
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }

        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(named: "starIcon_gray200"))
            star.contentMode = .scaleAspectFit
            stars.append(star)
            addSubview(star)
        }

        for (index, star) in stars.enumerated() {
            star.snp.makeConstraints { make in
                make.top.equalTo(questionLabel.snp.bottom).offset(20)
                make.width.height.equalTo(36)
                if index == 0 {
                    make.centerX.equalToSuperview().offset(-88)
                } else {
                    make.leading.equalTo(stars[index - 1].snp.trailing).offset(10)
                }
            }
        }

        stars.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
        }

        addGestureRecognizers()
    }

    // MARK: - Helpers
    private func updateStarImages() {
        for (index, star) in stars.enumerated() {
            let imageName = index < selectedRating ? "starIcon" : "starIcon_gray200"
            star.image = UIImage(named: imageName)
        }
    }

    private func provideHapticFeedback() {
        // 별 선택 상태가 변경될 때만 햅틱을 발생시킴
        guard selectedRating != lastGeneratedRating else { return }
        lastGeneratedRating = selectedRating
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }

    private func addGestureRecognizers() {
        for (index, star) in stars.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStarTapped(_:)))
            star.isUserInteractionEnabled = true
            star.tag = index + 1
            star.addGestureRecognizer(tapGesture)
        }

        // Add pan gesture for scrolling interaction
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }

    @objc private func handleStarTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedStar = gesture.view else { return }
        selectedRating = tappedStar.tag
        NotificationCenter.default.post(name: .ratingUpdated, object: nil)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self)
        
        if abs(velocity.x) > abs(velocity.y) {
            let touchLocation = gesture.location(in: self)
            for (index, star) in stars.enumerated() {
                if star.frame.contains(touchLocation) {
                    selectedRating = index + 1
                    NotificationCenter.default.post(name: .ratingUpdated, object: nil)
                    break
                }
            }
        } else {
            self.superview?.next?.touchesBegan([], with: nil)
        }
    }

    // MARK: - Public Methods
    func getSelectedRating() -> Int {
        return selectedRating
    }
}
