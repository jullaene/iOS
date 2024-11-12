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
        let height: CGFloat
    }
    
    // MARK: - UI Components
    private let framesData: [FrameData] = [
        FrameData(iconName: "scheduleIcon", title: "산책 일정", iconHeight: 22, height: 48),
        FrameData(iconName: "meetingPlace", title: "만남 장소", iconHeight: 17.5, height: 22),
        FrameData(iconName: "walkItems", title: "산책 용품", iconHeight: 18, height: 22),
        FrameData(iconName: "preMeeting", title: "사전 만남", iconHeight: 20, height: 22)
    ]
    
    private var frames: [UIView] = []
    
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
        setupFrames()
    }
    
    private func setupFrames() {
        var lastFrame: UIView? = nil
        
        for data in framesData {
            let frame = createFrame(data: data)
            addSubview(frame)
            
            frame.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(305)
                make.height.equalTo(data.height)
                make.top.equalTo(lastFrame?.snp.bottom ?? self.snp.top).offset(lastFrame == nil ? 20 : 24)
            }
            
            lastFrame = frame
            frames.append(frame)
        }
    }
    
    // MARK: - Helpers
    private func createFrame(data: FrameData) -> UIView {
        let frame = UIView()
        let icon = createIcon(named: data.iconName, height: data.iconHeight)
        let titleLabel = createTitleLabel(with: data.title)
        frame.addSubview(icon)
        frame.addSubview(titleLabel)
        
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(data.iconHeight)
            make.width.equalTo(icon.snp.height)
            make.centerY.equalTo(data.title == "산책 일정" ? titleLabel.snp.centerY : frame.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            
            if data.title == "산책 일정" {
                make.top.equalToSuperview()
            } else {
                make.centerY.equalToSuperview()
            }
        }
        
        if data.title == "산책 일정" {
            setupScheduleDetails(in: frame, relativeTo: titleLabel)
        } else {
            setupDetailLabel(in: frame, text: detailText(for: data.title))
        }
        
        return frame
    }
    
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
    
    private func setupDetailLabel(in frame: UIView, text: String?) {
        guard let text = text else { return }
        let detailLabel = UILabel()
        detailLabel.text = text
        detailLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        detailLabel.textColor = UIColor.mainBlue
        frame.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupScheduleDetails(in frame: UIView, relativeTo titleLabel: UIView) {
        let startLabel = createSubtitleLabel(with: "시작")
        let startDateLabel = createSubtitleLabel(with: "2024.10.25 (금) 16:00", color: .mainBlue)
        let endLabel = createSubtitleLabel(with: "종료")
        let endDateLabel = createSubtitleLabel(with: "2024.10.25 (금) 16:30", color: .mainBlue)
        
        frame.addSubview(startLabel)
        frame.addSubview(startDateLabel)
        frame.addSubview(endLabel)
        frame.addSubview(endDateLabel)
        
        startLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(8)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.left.equalTo(startLabel.snp.right).offset(4)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        endLabel.snp.makeConstraints { make in
            make.top.equalTo(startLabel.snp.bottom).offset(4)
            make.left.equalTo(startLabel)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.left.equalTo(endLabel.snp.right).offset(4)
            make.top.equalTo(startDateLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
        }
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
