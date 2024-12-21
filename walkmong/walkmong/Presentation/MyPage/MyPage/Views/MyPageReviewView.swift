//
//  MyPageReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit

class MyPageReviewView: UIView {
    
    // MARK: - Properties
    private let walkerReviewTitle = ReviewTitleView(title: "받은 산책자 후기", count: 5, showArrow: true)
    private let ownerReviewTitle = ReviewTitleView(title: "받은 반려인 후기")
    
    // User Rating
    private let userRatingView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: 15)
    private let userRatingTitleLabel = SmallTitleLabel(text: "전체 사용자 평가", textColor: .gray600)
    private let participantCountLabel = SmallMainParagraphLabel(text: "2명 참여", textColor: .gray400)
    private let starRatingLabel = MainHighlightParagraphLabel(text: "4.9", textColor: .gray600)
    private let radarChart = CustomRadarChartView()
    private let starIcon = UIImage.createImageView(named: "MyPageStarIcon")
    
    // Keyword
    private let keywordView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: 15)
    private let keywordTitleLabel = SmallTitleLabel(text: "김철수님의 키워드 TOP 3", textColor: .gray600)
    private let keywordBubbleContainer = UIView()
    private let largeBubble = UIView.createRoundedView(backgroundColor: .mainBlue, cornerRadius: 81)
    private let mediumBubble = UIView.createRoundedView(backgroundColor: .mainGreen, cornerRadius: 64)
    private let smallBubble = UIView.createRoundedView(backgroundColor: .gray400, cornerRadius: 54.5)
    private let largeBubbleLabel = SmallTitleLabel.createLabel(text: "# 친절해요", textColor: .white, lineHeightMultiple: 1.17)
    private let mediumBubbleLabel = SmallTitleLabel.createLabel(text: "# 연락이\n잘 되어요", textColor: .white, fontSize: 16, lineHeightMultiple: 1.17)
    private let smallBubbleLabel = SmallTitleLabel.createLabel(text: "# 반려견\n훈련이 잘\n되어있어요", textColor: .white, fontSize: 14, lineHeightMultiple: 1.17)
    
    // Owner Review
    private let ownerReviewView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: 15)
    private let ownerReviewTitleLabel = SmallTitleLabel(text: "김철수님의 반려인 후기", textColor: .gray600)
    private let participantLabel = SmallMainParagraphLabel(text: "10명 참여", textColor: .gray400)
    private let chartView = UIView.createRoundedView(backgroundColor: .clear, cornerRadius: 10)
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        // User Rating View
        addSubview(walkerReviewTitle)
        addSubview(userRatingView)
        userRatingView.addSubviews(userRatingTitleLabel, participantCountLabel, starRatingLabel, starIcon, radarChart)
        
        // Keyword View
        addSubview(keywordView)
        keywordView.addSubviews(keywordTitleLabel, keywordBubbleContainer)
        keywordBubbleContainer.addSubviews(mediumBubble, smallBubble, largeBubble)
        largeBubble.addSubview(largeBubbleLabel)
        mediumBubble.addSubview(mediumBubbleLabel)
        smallBubble.addSubview(smallBubbleLabel)
        
        // Owner Review View
        addSubview(ownerReviewTitle)
        addSubview(ownerReviewView)
        ownerReviewView.addSubviews(ownerReviewTitleLabel, participantLabel, chartView)
        
        setupChartView()
        setupWalkerReviewTapAction()
        setupOwnerReviewTapAction()
    }
    
    private func setupConstraints() {
        // Walker Review Title
        walkerReviewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        // User Rating
        userRatingView.snp.makeConstraints { make in
            make.top.equalTo(walkerReviewTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(340)
        }
        
        userRatingTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        participantCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(userRatingTitleLabel)
        }
        
        starRatingLabel.snp.makeConstraints { make in
            make.trailing.equalTo(participantCountLabel.snp.leading).offset(-11)
            make.centerY.equalTo(userRatingTitleLabel)
        }
        
        starIcon.snp.makeConstraints { make in
            make.trailing.equalTo(starRatingLabel.snp.leading).offset(-4)
            make.centerY.equalTo(userRatingTitleLabel)
            make.width.height.equalTo(20)
        }
        
        radarChart.snp.makeConstraints { make in
            make.top.equalTo(userRatingTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(245)
            make.height.equalTo(244)
        }
        
        // Keyword View
        keywordView.snp.makeConstraints { make in
            make.top.equalTo(userRatingView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(305)
        }
        
        keywordTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        keywordBubbleContainer.snp.makeConstraints { make in
            make.top.equalTo(keywordTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(221)
        }
        
        largeBubble.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview()
            make.width.height.equalTo(162)
        }
        
        mediumBubble.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(128)
        }
        
        smallBubble.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-21)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(109)
        }
        
        largeBubbleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mediumBubbleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        smallBubbleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Owner Review
        ownerReviewTitle.snp.makeConstraints { make in
            make.top.equalTo(keywordView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        ownerReviewView.snp.makeConstraints { make in
            make.top.equalTo(ownerReviewTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(128)
            make.bottom.lessThanOrEqualToSuperview().inset(40)
        }
        
        ownerReviewTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(19)
        }
        
        participantLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-19)
            make.centerY.equalTo(ownerReviewTitleLabel)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(ownerReviewTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(44)
        }
    }
    
    private func setupChartView() {
        let leftView = RoundedView(corners: [.topLeft, .bottomLeft], cornerRadius: 10, backgroundColor: .gray400)
        let rightView = RoundedView(corners: [.topRight, .bottomRight], cornerRadius: 10, backgroundColor: .mainBlue)
        
        // 텍스트 추가
        let leftLabel = SmallTitleLabel(text: "👍")
        leftLabel.textColor = .white
        leftLabel.transform = CGAffineTransform(rotationAngle: .pi)
        leftLabel.textAlignment = .center
        
        let rightLabel = SmallTitleLabel(text: "👍 90%")
        rightLabel.textColor = .white
        rightLabel.textAlignment = .center
        
        leftView.addSubview(leftLabel)
        rightView.addSubview(rightLabel)
        chartView.addSubviews(leftView, rightView)
        
        leftView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        rightView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    // 커스텀 UIView 클래스 정의
    class RoundedView: UIView {
        private let corners: UIRectCorner
        private let cornerRadius: CGFloat
        
        init(corners: UIRectCorner, cornerRadius: CGFloat, backgroundColor: UIColor) {
            self.corners = corners
            self.cornerRadius = cornerRadius
            super.init(frame: .zero)
            self.backgroundColor = backgroundColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    // MARK: - Update Methods
    func updateChartData(scores: [CGFloat]) {
        radarChart.updateScores(scores)
    }
    
    private func setupWalkerReviewTapAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(walkerReviewTitleTapped))
        walkerReviewTitle.addGestureRecognizer(tapGesture)
        walkerReviewTitle.isUserInteractionEnabled = true
    }

    @objc private func walkerReviewTitleTapped() {
        if let currentViewController = findViewController() {
            let walkerReviewVC = MyPageWalkerReviewViewController()
            currentViewController.navigationController?.pushViewController(walkerReviewVC, animated: true)
        }
    }
    
    private func setupOwnerReviewTapAction() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ownerReviewTitleTapped))
//        ownerReviewTitle.addGestureRecognizer(tapGesture)
        ownerReviewTitle.isUserInteractionEnabled = true
    }
    
//    @objc private func ownerReviewTitleTapped() {
//        if let currentViewController = findViewController() {
//            let ownerReviewVC = MyPageOwnerReviewViewController()
//            currentViewController.navigationController?.pushViewController(ownerReviewVC, animated: true)
//        }
//    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}

class ReviewTitleView: UIView {
    private let titleLabel: MiddleTitleLabel
    private var countLabel: MainHighlightParagraphLabel?
    private var arrowImageView: UIImageView?
    
    init(title: String, count: Int? = nil, showArrow: Bool = false) {
        self.titleLabel = MiddleTitleLabel(text: title)
        super.init(frame: .zero)
        
        if let count = count {
            countLabel = MainHighlightParagraphLabel(text: "\(count)개", textColor: .gray600)
        }
        
        if showArrow {
            arrowImageView = UIImageView(image: UIImage(named: "MyPageReviewArrow"))
            arrowImageView?.contentMode = .scaleAspectFit
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        
        if let countLabel = countLabel {
            addSubview(countLabel)
        }
        
        if let arrowImageView = arrowImageView {
            addSubview(arrowImageView)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        countLabel?.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
