//
//  MatchingApplyWalkRequestInformationInputView.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class MatchingApplyWalkRequestInformationInputView: UIView, CalendarViewDelegate {
    private var startTime: String = ""
    private var endTime: String = ""
    
    private var isStartTimeSelected: Bool = false
    private var isEndTimeSelected: Bool = false
    private var isSelection1Complete: Bool = false
    private var isSelection2Complete: Bool = false
    private var isSelection3Complete: Bool = false
    
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
    private let warningIcon: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "warningIcon") {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
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
    private let startHourLabel = MainHighlightParagraphLabel(text: "", textColor: .gray600)
    private let startMinuteLabel = MainHighlightParagraphLabel(text: "", textColor: .gray600)
    private let endHourLabel = MainHighlightParagraphLabel(text: "", textColor: .gray600)
    private let endMinuteLabel = MainHighlightParagraphLabel(text: "", textColor: .gray600)
    private var selectedTime: String = ""
    
    let selectionView1 = UIView()
    private let selectionView2 = UIView()
    let selectionView3 = UIView()
    
    weak var delegate: MatchingApplyWalkRequestInformationInputViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        customizeCalendarView()
        delegate?.updateActionButtonState(isEnabled: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews(
            smallTitle, warningIcon, warningText, containerView, dateView, timeSelectionView, selectionView1, selectionView2, selectionView3
        )
        
        containerView.addSubview(calendarView)
        dateView.addSubview(dateLabel)
        setupTimeSelectionView()
        
        setupLocationSelectionView(
            selectionView1,
            title: "만남 장소는 어떻게 정하고 싶으신가요?",
            warningText: "산책자가 정한 장소에서 만나면 더 빠르게 매칭할 수 있어요!",
            warningColor: .gray400,
            buttonTitles: [
                "산책자가 선택한 장소가 좋아요",
                "산책자와 상의하여 결정하고 싶어요"
            ]
        )
        
        setupLocationSelectionView(
            selectionView2,
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
            selectionView3,
            title: "산책 전 사전 만남이 가능한가요?",
            warningText: "사전 만남을 통해 반려견과 산책자가 친해질 수 있어요!",
            warningColor: .mainBlue,
            buttonTitles: [
                "가능해요",
                "불가능해요"
            ]
        )
        
        calendarView.delegate = self
        
        setupSelectionActions()
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
            make.top.equalTo(locationTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        locationWarningText.snp.makeConstraints { make in
            make.top.equalTo(locationWarningIcon.snp.top).offset(-3)
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
            button.addTarget(self, action: #selector(toggleSelection(_:)), for: .touchUpInside)
            
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
    
    @objc private func toggleSelection(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        
        if sender.isSelected {
            sender.setStyle(.dark, type: .largeSelectionCheck)
        } else {
            sender.setStyle(.light, type: .largeSelectionCheck)
        }
        
        updateSelectionCompletionState(for: sender.superview)
    }
    
    private func updateSelectionCompletionState(for view: UIView?) {
        guard let view = view else { return }
        
        if view == selectionView1 {
            isSelection1Complete = view.subviews.contains {
                guard let button = $0 as? UIButton else { return false }
                return button.isSelected
            }
        }
        
        if view == selectionView2 {
            isSelection2Complete = view.subviews.contains {
                guard let button = $0 as? UIButton else { return false }
                return button.isSelected
            }
        }
        
        if view == selectionView3 {
            isSelection3Complete = view.subviews.contains {
                guard let button = $0 as? UIButton else { return false }
                return button.isSelected
            }
        }
        
        updateActionButtonState()
    }
    
    private func updateActionButtonState() {
        let isAllConditionsMet = isStartTimeSelected && isEndTimeSelected &&
        isSelection1Complete && isSelection2Complete && isSelection3Complete
        delegate?.updateActionButtonState(isEnabled: isAllConditionsMet)
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
        
        selectionView1.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionView.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        selectionView2.snp.makeConstraints { make in
            make.top.equalTo(selectionView1.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        selectionView3.snp.makeConstraints { make in
            make.top.equalTo(selectionView2.snp.bottom).offset(Metrics.sectionSpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
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
        
        addTimePickerGesture(to: startHourView, timeLabel: startHourLabel, isStartTime: true)
        addTimePickerGesture(to: startMinuteView, timeLabel: startMinuteLabel, isStartTime: true)
        addTimePickerGesture(to: endHourView, timeLabel: endHourLabel, isStartTime: false)
        addTimePickerGesture(to: endMinuteView, timeLabel: endMinuteLabel, isStartTime: false)
        
        startHourView.tag = 1
        startMinuteView.tag = 2
        endHourView.tag = 3
        endMinuteView.tag = 4
        
        startHourView.addSubview(startHourLabel)
        startMinuteView.addSubview(startMinuteLabel)
        endHourView.addSubview(endHourLabel)
        endMinuteView.addSubview(endMinuteLabel)
        
        addTimePickerGesture(to: startHourView, timeLabel: startHourLabel, isStartTime: true)
        addTimePickerGesture(to: startMinuteView, timeLabel: startMinuteLabel, isStartTime: true)
        addTimePickerGesture(to: endHourView, timeLabel: endHourLabel, isStartTime: false)
        addTimePickerGesture(to: endMinuteView, timeLabel: endMinuteLabel, isStartTime: false)
        
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
        
        startHourView.addSubview(startHourLabel)
        startHourLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        startMinuteView.addSubview(startMinuteLabel)
        startMinuteLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        endHourView.addSubview(endHourLabel)
        endHourLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        endMinuteView.addSubview(endMinuteLabel)
        endMinuteLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func addTimePickerGesture(to view: UIView, timeLabel: UILabel, isStartTime: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: isStartTime ? #selector(didTapStartTimeView(_:)) : #selector(didTapEndTimeView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapStartTimeView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        showTimePicker(for: view)
    }
    
    @objc private func didTapEndTimeView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        showTimePicker(for: view)
    }
    
    private func showTimePicker(for view: UIView) {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.frame = UIScreen.main.bounds
        overlayView.tag = 999
        
        let timePickerContainer = UIView()
        timePickerContainer.backgroundColor = .white
        timePickerContainer.layer.cornerRadius = 10
        timePickerContainer.clipsToBounds = true
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.calendar = Calendar(identifier: .gregorian)
        timePicker.locale = Locale(identifier: "ko_KR")
        timePicker.timeZone = TimeZone.current
        timePicker.date = Date()
        
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.calendar = Calendar(identifier: .gregorian)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        confirmButton.addTarget(self, action: #selector(dismissTimePicker(_:)), for: .touchUpInside)
        
        confirmButton.tag = view.tag
        
        UIApplication.shared.keyWindow?.addSubview(overlayView)
        overlayView.addSubview(timePickerContainer)
        timePickerContainer.addSubview(timePicker)
        timePickerContainer.addSubview(confirmButton)
        
        timePickerContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(250)
        }
        
        timePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        timePicker.addTarget(self, action: #selector(handleTimePickerValueChange(_:)), for: .valueChanged)
    }
    
    @objc private func dismissTimePicker(_ sender: UIButton) {
        if let overlayView = UIApplication.shared.keyWindow?.viewWithTag(999) {
            overlayView.removeFromSuperview()
        }
        
        let timeComponents = selectedTime.split(separator: ":").map { String($0) }
        guard timeComponents.count == 2,
              let selectedHour = Int(timeComponents[0]),
              let selectedMinute = Int(timeComponents[1]) else {
            print("시간 선택 실패: \(selectedTime)")
            return
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        
        if sender.tag == 1 || sender.tag == 2 { // Start time
            isStartTimeSelected = true
            startHourLabel.text = String(format: "%02d", selectedHour)
            startMinuteLabel.text = String(format: "%02d", selectedMinute)
            
            if let dateComponents = calendarView.getSelectedDateComponents() {
                var updatedComponents = dateComponents
                updatedComponents.hour = selectedHour
                updatedComponents.minute = selectedMinute
                if let date = Calendar.current.date(from: updatedComponents) {
                    startTime = formatter.string(from: date)
                    print("Start time set: \(startTime)")
                }
            }
        } else if sender.tag == 3 || sender.tag == 4 { // End time
            isEndTimeSelected = true
            endHourLabel.text = String(format: "%02d", selectedHour)
            endMinuteLabel.text = String(format: "%02d", selectedMinute)
            
            if let dateComponents = calendarView.getSelectedDateComponents() {
                var updatedComponents = dateComponents
                updatedComponents.hour = selectedHour
                updatedComponents.minute = selectedMinute
                if let date = Calendar.current.date(from: updatedComponents) {
                    endTime = formatter.string(from: date)
                    print("End time set: \(endTime)")
                }
            }
        }
        
        delegate?.updateTimeSelection(startTime: startTime, endTime: endTime)
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
    
    private func setupTimePicker(for view: UIView, isStartTime: Bool) {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "ko_KR")
        
        timePicker.date = isStartTime ? Date() : Date().addingTimeInterval(60 * 60)
        
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        
        view.addSubview(timePicker)
        
        timePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let hourLabel = MainHighlightParagraphLabel(text: "00", textColor: .gray600)
        let minuteLabel = MainHighlightParagraphLabel(text: "00", textColor: .gray600)
        view.addSubviews(hourLabel, minuteLabel)
        
        hourLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(view).offset(8)
        }
        
        minuteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(hourLabel)
            make.leading.equalTo(hourLabel.snp.trailing).offset(4)
        }
    }
    
    @objc private func timePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: sender.date)
        print("선택된 시간: \(formattedTime)")
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
    
    private func setupSelectionActions() {
        let selectionViews = [selectionView1, selectionView2, selectionView3]
        
        for (index, view) in selectionViews.enumerated() {
            view.subviews.forEach { subview in
                if let button = subview as? UIButton {
                    button.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)
                    button.tag = index
                }
            }
        }
    }
    
    @objc private func handleSelection(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            isSelection1Complete = true
        case 1:
            isSelection2Complete = true
        case 2:
            isSelection3Complete = true
        default:
            break
        }
        sender.setStyle(.dark, type: .largeSelectionCheck)
        updateActionButtonState()
    }
    
    @objc private func handleTimePickerValueChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        selectedTime = formatter.string(from: sender.date)
        
        let selectedComponents = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        guard let selectedHour = selectedComponents.hour, let selectedMinute = selectedComponents.minute else {
            print("시간 선택 실패: hour 또는 minute 추출 실패")
            return
        }
        
    }
    
    private func showTimeValidationError(message: String) {
        
        if let viewController = self.getViewController() {
            let alertBuilder = CustomAlertViewController.CustomAlertBuilder(viewController: viewController)
                .setTitleState(.useTitleAndSubTitle)
                .setButtonState(.singleButton)
                .setTitleText("시간 오류")
                .setSubTitleText(message)
                .setSingleButtonTitle("확인")
                .setSingleButtonAction {
                    viewController.dismiss(animated: true)
                }
            
            alertBuilder.showAlertView()
        } else {
            print("viewController를 찾을 수 없음")
        }
    }
    
    func getSelectedText(from view: UIView) -> String {
        guard let button = view.subviews
            .compactMap({ $0 as? UIButton })
            .first(where: { $0.isSelected }) else {
            return "선택되지 않음"
        }
        return button.titleLabel?.text ?? "선택되지 않음"
    }
}
