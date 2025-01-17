//
//  MatchingStatusSoonView.swift
//  walkmong
//
//  Created by 황채웅 on 1/17/25.
//

import UIKit

protocol MatchingStatusSoonViewDelegate: AnyObject {
    
}

final class MatchingStatusSoonView: UIView {
    
    weak var delegate: MatchingStatusSoonViewDelegate?
    
    private let profileImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let matchingStatusLabel = MiddleTitleLabel(text: "현황", textColor: .mainBlack)
    
    private let subLabel = MainHighlightParagraphLabel(text: "부제목", textColor: .mainBlack)
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(.arrowIcon, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainBlue
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(profileImageview, matchingStatusLabel, subLabel, button)
    }
    
    private func setConstraints() {
        profileImageview.snp.makeConstraints { make in
            make.top.leading.equalTo(20)
            make.width.height.equalTo(81)
        }
        matchingStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageview.snp.top)
            make.leading.equalTo(profileImageview.snp.trailing).offset(16)
        }
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(matchingStatusLabel.snp.bottom).offset(12)
            make.leading.equalTo(matchingStatusLabel.snp.leading)
        }
        button.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(20)
            make.top.equalTo(profileImageview.snp.top)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    func setContent(startDate: String, endDate: String, dogName: String, dogProfileURL: String) {
        subLabel.text = calculateTimeLeft(startDate: startDate, endDate: endDate)
        let time = formatDateRange(start: startDate, end: endDate)
        if time == "-1" {
            matchingStatusLabel.text = "내일 \(dogName)의\n산책이 있어요."
        }else {
            matchingStatusLabel.text = "\(dogName)의\n산책 \(time) 전이에요."
        }
        profileImageview.setImage(from: dogProfileURL, placeholder: "puppy")
    }

    /// 시작 시간과 종료 시간으로 남은 시간을 계산
    private func calculateTimeLeft(startDate: String, endDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone.current
        
        let now = Date() // 현재 시간
        
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            return "시간 형식 오류"
        }
        
        if now < start { // 시작 전
            let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: start)
            
            if let day = components.day, day > 0 {
                return "-1" // 내일 시작
            } else if let hour = components.hour, hour >= 1 {
                return "\(hour)시간"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)분"
            } else {
                return "곧 시작"
            }
        } else if now >= start && now <= end { // 진행 중
            let components = Calendar.current.dateComponents([.hour, .minute], from: now, to: end)
            
            if let hour = components.hour, hour >= 1 {
                return "\(hour)시간"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)분"
            } else {
                return "종료됨"
            }
        } else { // 종료 후
            return "종료됨"
        }
    }

}
