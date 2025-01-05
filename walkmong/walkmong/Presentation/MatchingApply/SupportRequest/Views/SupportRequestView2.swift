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
    private let dateLabel = SmallTitleLabel(text: "dateLabel", textColor: .gray600)
    
    private let timeSelectionView = UIView() // 새로운 컨테이너 뷰 추가
    private let startEndTimeTitle = SmallTitleLabel(text: "산책 시작/종료 시간을 선택해주세요.", textColor: .gray600)
    private let startLabel = MainHighlightParagraphLabel(text: "산책 시작 시간", textColor: .gray600)
    private lazy var startHourView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
    private let startSeparateText = MainHighlightParagraphLabel(text: ":", textColor: .gray600)
    private lazy var startMinuteView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
    private let endLabel = MainHighlightParagraphLabel(text: "산책 종료 시간", textColor: .gray600)
    private lazy var endHourView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
    private let endSeparateText = MainHighlightParagraphLabel(text: ":", textColor: .gray600)
    private lazy var endMinuteView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
    
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
            smallTitle, warningIcon, warningText, containerView, dateView, timeSelectionView
        )
        
        containerView.addSubview(calendarView)
        dateView.addSubview(dateLabel)
        
        timeSelectionView.addSubviews(
            startEndTimeTitle, startLabel, startHourView, startSeparateText,
            startMinuteView, endLabel, endHourView, endSeparateText, endMinuteView
        )
        
        calendarView.delegate = self
        print("Delegate set for calendarView")
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
        
        startEndTimeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        startLabel.snp.makeConstraints { make in
            make.top.equalTo(startEndTimeTitle.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.equalToSuperview()
        }
        
        endLabel.snp.makeConstraints { make in
            make.top.equalTo(startLabel.snp.top)
            make.leading.equalTo(startLabel.snp.trailing).offset(90)
        }
        
        setupTimeViewConstraints(
            startHourView,
            startSeparateText,
            startMinuteView,
            startLabel.snp.bottom,
            topOffset: 12,
            alignWith: startLabel
        )

        setupTimeViewConstraints(
            endHourView,
            endSeparateText,
            endMinuteView,
            endLabel.snp.bottom,
            topOffset: 12,
            alignWith: endLabel
        )
    }
    
    private func setupTimeViewConstraints(
        _ hourView: UIView,
        _ separator: UILabel,
        _ minuteView: UIView,
        _ topAnchor: ConstraintRelatableTarget,
        topOffset: CGFloat = 0,
        alignWith: UIView? = nil
    ) {
        let alignmentView = alignWith ?? hourView
        
        hourView.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(topOffset)
            make.leading.equalTo(alignmentView.snp.leading)
            make.height.equalTo(Metrics.inputHeight)
            make.width.equalTo(Metrics.inputWidth)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.equalTo(hourView.snp.trailing).offset(Metrics.smallInset)
            make.centerY.equalTo(hourView)
        }
        
        minuteView.snp.makeConstraints { make in
            make.top.equalTo(hourView)
            make.leading.equalTo(separator.snp.trailing).offset(Metrics.smallInset)
            make.height.equalTo(Metrics.inputHeight)
            make.width.equalTo(Metrics.inputWidth)
        }
    }
    
    private func customizeCalendarView() {
        calendarView.dayCollectionView.isScrollEnabled = true
        calendarView.dayCollectionView.alwaysBounceHorizontal = true
        calendarView.updateSectionInset(top: 0, left: Metrics.inset, bottom: 0, right: Metrics.inset)
        calendarView.reloadCalendar()
    }
    
    private func updateDateLabel() {
        if let selectedDate = calendarView.getSelectedDate() {
            dateLabel.text = selectedDate
        } else {
            print("No date selected.")
            dateLabel.text = "날짜를 선택해주세요."
        }
    }
    
    func didSelectDate(_ date: String) {
        print("didSelectDate called with date: \(date)")
        if let fullFormattedDate = calendarView.getSelectedDateWithFullFormat() {
            dateLabel.text = fullFormattedDate
            print("dateLabel updated to: \(fullFormattedDate)")
        } else {
            print("Failed to get full formatted date.")
        }
    }
    
    // MARK: - Helper Methods
    private static func createImageView(named: String, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: named)
        imageView.contentMode = contentMode
        return imageView
    }
}
