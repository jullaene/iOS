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
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
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
                    self.referenceIcon = icon
                } else {
                    // 이후 아이콘은 첫 번째 아이콘의 centerX에 정렬
                    make.centerX.equalTo(referenceIcon!)
                }
                
                if data.title == "만남 장소" {
                    // "만남 장소"는 endLabel의 아래로 배치
                    make.top.equalTo(endLabel!.snp.bottom).offset(24)
                } else {
                    make.top.equalTo(lastView?.snp.bottom ?? self.snp.top).offset(lastView == nil ? 20 : 24)
                }
            }
            
            // 타이틀 레이아웃
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalTo(icon.snp.centerY)
                
                if index == 0 {
                    // 첫 번째 타이틀은 아이콘의 오른쪽에 배치
                    make.left.equalTo(icon.snp.right).offset(8)
                    self.referenceTitleLabel = titleLabel
                } else {
                    // 이후 타이틀은 첫 번째 타이틀의 leading에 정렬
                    make.left.equalTo(referenceTitleLabel!)
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
        detailLabel.text = detailText(for: title)
        detailLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        detailLabel.textColor = UIColor.mainBlue
        addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func setupScheduleDetails(relativeTo titleLabel: UILabel) {
        let startLabel = createSubtitleLabel(with: "시작")
        let startDateLabel = createSubtitleLabel(with: "2024.10.25 (금) 16:00", color: .mainBlue)
        let endLabel = createSubtitleLabel(with: "종료")
        let endDateLabel = createSubtitleLabel(with: "2024.10.25 (금) 16:30", color: .mainBlue)
        
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
        
        self.endLabel = endLabel // endLabel 참조 저장
    }
    
    private func createSubtitleLabel(with text: String, color: UIColor = .gray400) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = color
        return label
    }
    
    private func detailText(for title: String) -> String? {
        switch title {
        case "만남 장소":
            return "산책자 선택 장소"
        case "산책 용품", "사전 만남":
            return "제공 가능"
        default:
            return nil
        }
    }
}
