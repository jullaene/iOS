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
    private let locationSelectionView = UIView()
    
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
            smallTitle, warningIcon, warningText, containerView, dateView, timeSelectionView, locationSelectionView
        )
        
        containerView.addSubview(calendarView)
        dateView.addSubview(dateLabel)
        setupTimeSelectionView()
        setupLocationSelectionView()
        
        calendarView.delegate = self
    }
    
    private func setupTimeSelectionView() {
        let startEndTimeTitle = SmallTitleLabel(text: "산책 시작/종료 시간을 선택해주세요.", textColor: .gray600)
        let startLabel = MainHighlightParagraphLabel(text: "산책 시작 시간", textColor: .gray600)
        let startHourView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
        let startSeparateText = MainHighlightParagraphLabel(text: ":", textColor: .gray600)
        let startMinuteView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
        let endLabel = MainHighlightParagraphLabel(text: "산책 종료 시간", textColor: .gray600)
        let endHourView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
        let endSeparateText = MainHighlightParagraphLabel(text: ":", textColor: .gray600)
        let endMinuteView = UIView.createRoundedView(backgroundColor: .gray100, cornerRadius: Metrics.smallCornerRadius)
        
        timeSelectionView.addSubviews(
            startEndTimeTitle, startLabel, startHourView, startSeparateText,
            startMinuteView, endLabel, endHourView, endSeparateText, endMinuteView
        )
        
        startEndTimeTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
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
            startHourView, startSeparateText, startMinuteView,
            startLabel.snp.bottom, topOffset: 12, alignWith: startLabel
        )
        
        setupTimeViewConstraints(
            endHourView, endSeparateText, endMinuteView,
            endLabel.snp.bottom, topOffset: 12, alignWith: endLabel
        )
    }
    
    private func setupLocationSelectionView() {
        let locationTitle = SmallTitleLabel(text: "만남 장소는 어떻게 정하고 싶으신가요?", textColor: .gray600)
        let locationWarningIcon = Self.createImageView(named: "warningIcon", contentMode: .scaleAspectFit)
        let locationWarningText = SmallMainHighlightParagraphLabel(
            text: "산책자가 정한 장소에서 만나면 더 빠르게 매칭할 수 있어요!",
            textColor: .gray400
        )
        
        // LocationSelectionView에 추가
        locationSelectionView.addSubviews(locationTitle, locationWarningIcon, locationWarningText)
        
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
        
        locationSelectionView.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionView.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    private func setupTimeViewConstraints(
        _ hourView: UIView, _ separator: UILabel, _ minuteView: UIView,
        _ topAnchor: ConstraintRelatableTarget, topOffset: CGFloat = 0, alignWith: UIView? = nil
    ) {
        let alignmentView = alignWith ?? hourView
        
        hourView.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(topOffset)
            make.leading.equalTo(alignmentView.snp.leading)
            make.height.equalTo(Metrics.inputHeight)
            make.width.equalTo(Metrics.inputWidth)
            make.bottom.equalToSuperview().inset(24)
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
        if let fullFormattedDate = calendarView.getSelectedDateWithFullFormat() {
            dateLabel.text = fullFormattedDate
        } else {
            print("날짜가 선택되지 않았습니다.")
            dateLabel.text = "날짜를 선택해주세요."
        }
    }
    
    func didSelectDate(_ date: String) {
        if let fullFormattedDate = calendarView.getSelectedDateWithFullFormat() {
            dateLabel.text = fullFormattedDate
        } else {
            print("전체 형식 날짜를 가져오지 못했습니다.")
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
