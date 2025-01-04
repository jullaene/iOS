//
//  SupportRequestView2.swift
//  walkmong
//
//  Created by 신호연 on 1/4/25.
//

import UIKit
import SnapKit

final class SupportRequestView2: UIView {
    
    // MARK: - Properties
    private let smallTitle = SmallTitleLabel(text: "산책 날짜를 선택해주세요.")
    private let warningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "warningIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let warningText = SmallMainHighlightParagraphLabel(text: "오늘부터 2주 이내의 날짜를 선택하실 수 있어요.", textColor: .gray400)
    private let containerView = UIView()
    let calendarView = CalendarView()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        customizeCalendarView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews(smallTitle, warningIcon, warningText, containerView)
        containerView.addSubview(calendarView)
        setupConstraints()
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
            make.top.equalTo(smallTitle.snp.bottom).offset(5)
            make.leading.equalTo(warningIcon.snp.trailing).offset(4)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(warningText.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(-20)
            make.height.equalTo(97)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func customizeCalendarView() {
        calendarView.dayCollectionView.isScrollEnabled = true
        calendarView.dayCollectionView.alwaysBounceHorizontal = true
        calendarView.updateSectionInset(top: 0, left: 20, bottom: 0, right: 20)
        calendarView.reloadCalendar()
    }
}
