//
//  MyPageReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/11/24.
//

import UIKit
import SnapKit
import Charts

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
        addSubviews(walkerReviewTitle, userRatingView)
        userRatingView.addSubviews(userRatingTitleLabel, participantCountLabel, starRatingLabel, starIcon, radarChart)
        
        // Keyword View
        addSubview(keywordView)
        keywordView.addSubviews(keywordTitleLabel, keywordBubbleContainer)
        
        // Owner Review View
        addSubviews(ownerReviewTitle, ownerReviewView)
        ownerReviewView.addSubviews(ownerReviewTitleLabel, participantLabel, chartView)
        
        setupChartView()
        setupWalkerReviewTapAction()
        setupOwnerReviewTapAction()
        setupDonutChart()
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
            make.height.equalTo(333)
        }
        
        keywordTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        keywordBubbleContainer.snp.makeConstraints { make in
            make.top.equalTo(keywordTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(13)
            make.height.equalTo(245)
            make.bottom.equalToSuperview().inset(20)
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
        let leftView = UIView()
        leftView.backgroundColor = .gray400
        leftView.layer.cornerRadius = 10
        leftView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        leftView.clipsToBounds = true

        let rightView = UIView()
        rightView.backgroundColor = .mainBlue
        rightView.layer.cornerRadius = 10
        rightView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        rightView.clipsToBounds = true

        let leftLabel = SmallTitleLabel(text: "👍")
        leftLabel.textColor = .white
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
    
    private func setupDonutChart() {
        // 1. 데이터 설정
        let entries: [PieChartDataEntry] = [
            PieChartDataEntry(value: 40, label: "친절해요"),
            PieChartDataEntry(value: 30, label: "연락이 잘 되어요"),
            PieChartDataEntry(value: 20, label: "반려견 훈련이 잘 되어있어요"),
            PieChartDataEntry(value: 10, label: "기타")
        ]
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [.mainBlue, .gray500, .gray400, .gray300]
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 0
        dataSet.selectionShift = 0
        
        let chartData = PieChartData(dataSet: dataSet)
        
        // 2. 도넛 차트 설정
        let donutChart = PieChartView()
        donutChart.data = chartData
        donutChart.holeRadiusPercent = 0.36
        donutChart.transparentCircleRadiusPercent = 0
        donutChart.legend.enabled = false
        donutChart.chartDescription.enabled = false
        donutChart.holeColor = .clear
        donutChart.drawEntryLabelsEnabled = false
        
        // 3. 도넛 차트 추가
        keywordBubbleContainer.addSubview(donutChart)
        donutChart.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 244, height: 244))
        }
        
        // 4. LegendView 추가
        let legendView = createLegendView(for: entries, colors: dataSet.colors)
        keywordBubbleContainer.addSubview(legendView)
        legendView.snp.makeConstraints { make in
            make.leading.equalTo(donutChart.snp.trailing).offset(16)
            make.top.equalTo(donutChart)
            make.trailing.equalToSuperview()
            make.width.equalTo(80)
        }
    }
    
    // 범례 뷰 생성
    private func createLegendView(for entries: [PieChartDataEntry], colors: [UIColor]) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        for (index, entry) in entries.enumerated() {
            let colorView = UIView()
            colorView.backgroundColor = colors[index]
            colorView.layer.cornerRadius = 4
            colorView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 8, height: 8))
            }
            
            let labelStackView = UIStackView()
            labelStackView.axis = .vertical
            labelStackView.spacing = 2
            
            let mainLabel = SmallMainHighlightParagraphLabel(text: entry.label ?? "", textColor: .gray500)
            mainLabel.numberOfLines = 0
            mainLabel.lineBreakMode = .byWordWrapping
            mainLabel.preferredMaxLayoutWidth = 80
            labelStackView.addArrangedSubview(mainLabel)
            
            if entry.label != "기타" {
                let percentLabel = CaptionLabel(text: "\(Int(entry.value))%", textColor: .gray400)
                percentLabel.numberOfLines = 1
                percentLabel.lineBreakMode = .byClipping
                labelStackView.addArrangedSubview(percentLabel)
            }
            
            let horizontalStack = UIStackView(arrangedSubviews: [colorView, labelStackView])
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 8
            horizontalStack.alignment = .center
            stackView.addArrangedSubview(horizontalStack)
        }
        
        return stackView
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
