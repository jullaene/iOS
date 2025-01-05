//
//  SupportRequestView2.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class SupportRequestView2: UIView, CalendarViewDelegate {
    
    // MARK: - Constants
    private enum Metrics {
        static let cornerRadius: CGFloat = 10
        static let smallCornerRadius: CGFloat = 5
        static let sectionSpacing: CGFloat = 28
        static let subSectionSpacing: CGFloat = 19
        static let inputHeight: CGFloat = 42
        static let inputWidth: CGFloat = 70
        static let inset: CGFloat = 20
        static let smallInset: CGFloat = 4
    }
    
    // MARK: - Properties
    private let smallTitle = SmallTitleLabel(text: "산책 날짜를 선택해주세요.", textColor: .gray600)
    private let warningIcon = createImageView(named: "warningIcon", contentMode: .scaleAspectFit)
    private let warningText = SmallMainHighlightParagraphLabel(
        text: "오늘부터 2주 이내의 날짜를 선택하실 수 있어요.",
        textColor: .gray400
    )
    private let containerView = UIView()
    let calendarView = CalendarView()
    private let dateView = UIView.createRoundedView(backgroundColor: .gray200, cornerRadius: Metrics.cornerRadius)
    private let dateLabel: SmallTitleLabel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (EEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        let currentDate = formatter.string(from: Date())
        return SmallTitleLabel(text: currentDate, textColor: .gray600)
    }()
    
    private let timeSelectionView = UIView()
    private let locationSelectionView1 = UIView()
    private let locationSelectionView2 = UIView()
    private let locationSelectionView3 = UIView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        customizeCalendarView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews(
            smallTitle, warningIcon, warningText, containerView, dateView, timeSelectionView, locationSelectionView1, locationSelectionView2, locationSelectionView3
        )
        
        containerView.addSubview(calendarView)
        dateView.addSubview(dateLabel)
        setupTimeSelectionView()
        
        // Reuse the location selection setup with different configurations
        setupLocationSelectionView(
            locationSelectionView1,
            title: "만남 장소는 어떻게 정하고 싶으신가요?",
            warningText: "산책자가 정한 장소에서 만나면 더 빠르게 매칭할 수 있어요!",
            warningColor: .gray400,
            buttonTitles: [
                "산책자가 선택한 장소가 좋아요",
                "산책자와 상의하여 결정하고 싶어요"
            ]
        )
        
        setupLocationSelectionView(
            locationSelectionView2,
            title: "산책 용품 준비가 완료되었나요?",
            warningText: "아래 3개 용품은 구비가 되어 있어야 산책이 가능해요!",
            warningColor: .mainBlue,
            buttonTitles: [
                "배변봉투가 구비 되었어요",
                "입마개가 구비 되었어요",
                "리드줄(목줄)이 구비 되었어요"
            ]
        )
        
        setupLocationSelectionView(
            locationSelectionView3,
            title: "산책 전 사전 만남이 가능한가요?",
            warningText: "사전 만남을 통해 반려견과 산책자가 친해질 수 있어요!",
            warningColor: .mainBlue,
            buttonTitles: [
                "가능해요",
                "불가능해요"
            ]
        )
        
        calendarView.delegate = self
    }
    
    private func setupLocationSelectionView(
        _ view: UIView,
        title: String,
        warningText: String,
        warningColor: UIColor,
        buttonTitles: [String]
    ) {
        let locationTitle = SmallTitleLabel(text: title, textColor: .gray600)
        let locationWarningIcon = Self.createImageView(named: "warningIcon", contentMode: .scaleAspectFit)
        locationWarningIcon.tintColor = warningColor
        let locationWarningText = SmallMainHighlightParagraphLabel(text: warningText, textColor: warningColor)
        
        view.addSubviews(locationTitle, locationWarningIcon, locationWarningText)
        
        locationTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        locationWarningIcon.snp.makeConstraints { make in
            make.top.equalTo(locationTitle.snp.bottom).offset(Metrics.smallInset)
            make.leading.equalToSuperview()
        }
        
        locationWarningText.snp.makeConstraints { make in
            make.centerY.equalTo(locationWarningIcon.snp.centerY)
            make.leading.equalTo(locationWarningIcon.snp.trailing).offset(Metrics.smallInset)
            make.trailing.equalToSuperview()
        }
        
        var previousButton: UIButton? = nil
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton.createStyledButton(
                type: .largeSelectionCheck,
                style: .light,
                title: title
            )
            button.tag = index + 1
            button.addTarget(self, action: #selector(toggleExclusiveButton(_:)), for: .touchUpInside)
            
            view.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(46)
                if let prev = previousButton {
                    make.top.equalTo(prev.snp.bottom).offset(12)
                } else {
                    make.top.equalTo(locationWarningText.snp.bottom).offset(16)
                }
                if index == buttonTitles.count - 1 {
                    make.bottom.equalToSuperview().inset(24)
                }
            }
            previousButton = button
        }
    }
    
    private func setupConstraints() {
        smallTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        warningIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(warningText.snp.centerY)
        }
        
        warningText.snp.makeConstraints { make in
            make.top.equalTo(smallTitle.snp.bottom).offset(Metrics.smallInset)
            make.leading.equalTo(warningIcon.snp.trailing).offset(Metrics.smallInset)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(warningText.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview().inset(-Metrics.inset)
            make.height.equalTo(97)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(Metrics.subSectionSpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timeSelectionView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview()
        }
        
        locationSelectionView1.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionView.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        locationSelectionView2.snp.makeConstraints { make in
            make.top.equalTo(locationSelectionView1.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        locationSelectionView3.snp.makeConstraints { make in
            make.top.equalTo(locationSelectionView2.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupTimeSelectionView() {
        // 시간 선택 뷰 초기화 (제공된 메서드 사용)
    }
    
    private func customizeCalendarView() {
        calendarView.dayCollectionView.isScrollEnabled = true
        calendarView.dayCollectionView.alwaysBounceHorizontal = true
        calendarView.updateSectionInset(top: 0, left: Metrics.inset, bottom: 0, right: Metrics.inset)
        calendarView.reloadCalendar()
    }
    
    func didSelectDate(_ date: String) {
        if let fullFormattedDate = calendarView.getSelectedDateWithFullFormat() {
            dateLabel.text = fullFormattedDate
        } else {
            print("전체 형식 날짜를 가져오지 못했습니다.")
        }
    }
    
    @objc private func toggleExclusiveButton(_ sender: UIButton) {
        sender.superview?.subviews.forEach {
            if let button = $0 as? UIButton {
                button.setStyle(.light, type: .largeSelectionCheck)
            }
        }
        sender.setStyle(.dark, type: .largeSelectionCheck)
    }
    
    private static func createImageView(named: String, contentMode: UIView.ContentMode, tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView()
        if let image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate) {
            imageView.image = image
        }
        imageView.contentMode = contentMode
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        return imageView
    }
}
