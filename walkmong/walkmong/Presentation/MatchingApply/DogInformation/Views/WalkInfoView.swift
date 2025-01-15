//
//  WalkInfoView.swift
//  walkmong
//
//  Created by 신호연 on 11/11/24.
//

import UIKit
import SnapKit

class WalkInfoView: UIView {
    
    // MARK: - Data Models
    private struct FrameData {
        let iconName: String
        let title: String
        let iconHeight: CGFloat
    }
    
    // MARK: - UI Components
    private let framesData: [FrameData] = [
        FrameData(iconName: "scheduleIcon", title: "산책 일정", iconHeight: 22),
        FrameData(iconName: "meetingPlace", title: "만남 장소", iconHeight: 17.5),
        FrameData(iconName: "walkItems", title: "산책 용품", iconHeight: 18),
        FrameData(iconName: "preMeeting", title: "사전 만남", iconHeight: 20)
    ]
    
    private var referenceIcon: UIImageView?
    private var referenceTitleLabel: UILabel?
    private var endLabel: UILabel?
    private var detailLabels: [String: UILabel] = [:]
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20
        
        var lastView: UIView? = nil
        
        for (index, data) in framesData.enumerated() {
            let icon = createIcon(named: data.iconName, height: data.iconHeight)
            let titleLabel = createTitleLabel(with: data.title)
            
            addSubview(icon)
            addSubview(titleLabel)
            
            // 아이콘 레이아웃
            icon.snp.makeConstraints { make in
                make.height.equalTo(data.iconHeight)
                make.width.equalTo(icon.snp.height)
                
                if index == 0 {
                    // 첫 번째 아이콘은 중심에 배치
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(20)
                    self.referenceIcon = icon
                } else if let referenceIcon = referenceIcon {
                    // 이후 아이콘은 첫 번째 아이콘의 centerX에 정렬
                    make.centerX.equalTo(referenceIcon)
                }
                
                if data.title == "만남 장소", let endLabel = endLabel {
                    // "만남 장소"는 endLabel의 아래로 배치
                    make.top.equalTo(endLabel.snp.bottom).offset(24)
                } else if let lastView = lastView {
                    make.top.equalTo(lastView.snp.bottom).offset(24)
                } else {
                    make.top.equalToSuperview().offset(20)
                }
            }
            
            // 타이틀 레이아웃
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalTo(icon.snp.centerY)
                
                if index == 0 {
                    // 첫 번째 타이틀은 아이콘의 오른쪽에 배치
                    make.left.equalTo(icon.snp.right).offset(8)
                    self.referenceTitleLabel = titleLabel
                } else if let referenceTitleLabel = referenceTitleLabel {
                    // 이후 타이틀은 첫 번째 타이틀의 leading에 정렬
                    make.left.equalTo(referenceTitleLabel)
                }
            }
            
            // 세부 레이블 추가
            if data.title == "산책 일정" {
                setupScheduleDetails(relativeTo: titleLabel)
            } else {
                setupDetailLabel(title: data.title, relativeTo: titleLabel)
            }
            
            lastView = icon // 다음 뷰의 기준점
        }
        
        if let lastView = lastView {
            lastView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
    
    // MARK: - Public Methods
    func updateDetails(
        date: String,
        startTime: String,
        endTime: String,
        locationNegotiationYn: String,
        suppliesProvidedYn: String,
        preMeetAvailableYn: String
    ) {
        let formattedStartTime = "".formattedDateAndTime(date: date, time: startTime) ?? "시간 정보 없음"
        let formattedEndTime = "".formattedDateAndTime(date: date, time: endTime) ?? "시간 정보 없음"

        detailLabels["startDate"]?.text = formattedStartTime
        detailLabels["endDate"]?.text = formattedEndTime

        detailLabels["만남 장소"]?.text = locationNegotiationYn == "Y" ? "산책자 선택 장소" : "협의 필요"
        detailLabels["산책 용품"]?.text = suppliesProvidedYn == "Y" ? "제공 가능" : "제공 불가능"
        detailLabels["사전 만남"]?.text = preMeetAvailableYn == "Y" ? "가능" : "불가능"
    }
    
    // MARK: - Helpers
    private func createIcon(named name: String, height: CGFloat) -> UIImageView {
        let icon = UIImageView(image: UIImage(named: name))
        return icon
    }
    
    private func createTitleLabel(with text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        titleLabel.textColor = UIColor.gray500
        return titleLabel
    }
    
    private func setupDetailLabel(title: String, relativeTo titleLabel: UILabel) {
        let detailLabel = UILabel()
        detailLabel.text = ""
        detailLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        detailLabel.textColor = UIColor.mainBlue
        addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        detailLabels[title] = detailLabel
    }
    
    private func setupScheduleDetails(relativeTo titleLabel: UILabel) {
        let startLabel = createSubtitleLabel(with: "시작")
        let startDateLabel = createSubtitleLabel(with: "", color: .mainBlue)
        let endLabel = createSubtitleLabel(with: "종료")
        let endDateLabel = createSubtitleLabel(with: "", color: .mainBlue)
        
        addSubview(startLabel)
        addSubview(startDateLabel)
        addSubview(endLabel)
        addSubview(endDateLabel)
        
        startLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.left.equalTo(startLabel.snp.right).offset(4)
            make.centerY.equalTo(startLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        endLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.top.equalTo(startLabel.snp.bottom).offset(4)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.left.equalTo(endLabel.snp.right).offset(4)
            make.centerY.equalTo(endLabel.snp.centerY)
        }
        
        detailLabels["startDate"] = startDateLabel
        detailLabels["endDate"] = endDateLabel

        self.endLabel = endLabel
    }
    
    private func createSubtitleLabel(with text: String, color: UIColor = .gray400) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = color
        return label
    }
}

extension String {
    func formattedDateAndTime(date: String, time: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let fullDateTimeString = "\(date) \(time)"
        guard let dateObject = dateFormatter.date(from: fullDateTimeString) else { return nil }

        dateFormatter.dateFormat = "MM.dd (E) HH:mm"
        return dateFormatter.string(from: dateObject)
    }
}
