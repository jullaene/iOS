//
//  MatchingStatusListCollectionViewCell.swift
//  walkmong
//
//  Created by 황채웅 on 1/11/25.
//

import UIKit

protocol MatchingStatusListCollectionViewCellDelegate: AnyObject {
    func didTapMatchingStatusListCollectionViewCell(matchingResponseData: MatchingStatusListResponseData, record: Record, status: Status)
}

final class MatchingStatusListCollectionViewCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let dateLabel = SmallTitleLabel(text: "산책 일정")
    private let matchingStateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.5
        return view
    }()
    private let matchingStateLabel = CaptionLabel(text: "매칭 상태", textColor: .white)
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .puppyImage01
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let dogNameLabel = MainHighlightParagraphLabel(text: "반려견명", textColor: .mainBlack)
    private let dogGenderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .femaleIcon
        return imageView
    }()
    private let addressLabel = SmallMainHighlightParagraphLabel(text: "주소", textColor: .gray500)
    private let addressIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .locationIcon
        return imageView
    }()
    private let seeInfoButtonViewFrame: UIView = {
        let frame = UIView()
        frame.backgroundColor = .gray200
        frame.layer.cornerRadius = 15
        frame.clipsToBounds = true
        return frame
    }()
    
    private lazy var seeInfoLabelFrame: UIView = {
        let frame = UIView()
        frame.backgroundColor = .clear
        return frame
    }()
    
    private let seeInfoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    private let seeInfoLabel = SmallMainHighlightParagraphLabel(text: "지원 정보 보기")
    private lazy var peopleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .people
        return imageView
    }()
    
    private lazy var peopleCountLabel = SmallMainParagraphLabel(text: "10")
    
    private var matchingData: MatchingStatusListResponseData!
    private var record: Record!
    private var status: Status!
    
    weak var delegate: MatchingStatusListCollectionViewCellDelegate?
    
    // 셀 재사용으로 인한 문제 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        setNeedsLayout()
        layoutIfNeeded()
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        for subview in seeInfoButtonViewFrame.subviews {
            subview.removeFromSuperview()
        }
        for subview in seeInfoButtonViewFrame.subviews {
            subview.removeFromSuperview()
        }
    }


    private func addSubview() {
        self.addSubview(containerView)
        containerView.addSubviews(dateLabel, matchingStateView, profileImageView, dogNameLabel, dogGenderIcon, addressIcon, addressLabel, seeInfoButtonViewFrame)
        matchingStateView.addSubview(matchingStateLabel)
        if record == .requested && status == .PENDING {
            // 지원한 산책자 목록 보여줌
            seeInfoButtonViewFrame.addSubview(seeInfoLabelFrame)
            seeInfoLabelFrame.addSubviews(seeInfoLabel, peopleIcon, peopleCountLabel)
        }else{
            // 기본 버튼 보여줌
            seeInfoButtonViewFrame.addSubview(seeInfoLabel)
        }
        if record == .requested && status == .CONFIRMED {
            //TODO: "산책자 김도비님" 라벨 + 이미지뷰 추가
        }
        // 진짜 동작할 버튼
        containerView.addSubview(seeInfoButton)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(20.5)
        }
        matchingStateView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(29)
            make.width.equalTo(67)
        }
        matchingStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(109)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-20)
        }
        seeInfoButtonViewFrame.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(45)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        dogNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(profileImageView.snp.top)
        }
        dogGenderIcon.snp.makeConstraints { make in
            make.leading.equalTo(dogNameLabel.snp.trailing).offset(5.5)
            make.centerY.equalTo(dogNameLabel.snp.centerY)
            make.height.equalTo(16)
        }
        addressIcon.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.height.equalTo(14)
            make.top.equalTo(dogNameLabel.snp.bottom).offset(7)
        }
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addressIcon.snp.centerY)
            make.leading.equalTo(addressIcon.snp.trailing).offset(2.5)
        }
        if record == .requested && status == .PENDING {
            // 지원한 산책자 목록 보여줌
            seeInfoLabelFrame.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.equalTo(seeInfoLabel.snp.leading)
                make.verticalEdges.equalToSuperview()
                make.trailing.equalTo(peopleCountLabel.snp.trailing)
            }
            seeInfoLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            peopleIcon.snp.makeConstraints { make in
                make.height.width.equalTo(16)
                make.centerY.equalToSuperview()
                make.leading.equalTo(seeInfoLabel.snp.trailing).offset(4)
            }
            peopleCountLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(peopleIcon.snp.trailing).offset(2)
            }
        }else {
            // 기본 버튼 보여줌
            seeInfoLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        if record == .requested && status == .CONFIRMED {
            //TODO: "산책자 김도비님" 라벨 + 이미지뷰 추가
        }
        seeInfoButton.snp.makeConstraints { make in
            make.edges.equalTo(seeInfoButtonViewFrame)
        }
    }
    
    private func setUI() {
        matchingStateLabel.text = status.rawValue
        switch status {
        case .PENDING:
            matchingStateView.backgroundColor = .lightBlue
            matchingStateLabel.textColor = .mainBlue
            dateLabel.textColor = .gray600
        case .CONFIRMED:
            matchingStateView.backgroundColor = .mainBlue
            matchingStateLabel.textColor = .white
            dateLabel.textColor = .gray600
        case .COMPLETED:
            matchingStateView.backgroundColor = .gray400
            matchingStateLabel.textColor = .white
            dateLabel.textColor = .gray300
        case .REJECTED:
            matchingStateView.backgroundColor = .gray200
            matchingStateLabel.textColor = .gray400
            dateLabel.textColor = .gray300
        case .none:
            return
        }
    }
    
    func setContent(with data: MatchingStatusListResponseData, status: Status, record: Record) {
        self.status = status
        self.record = record
        self.matchingData = data
        addSubview()
        setConstraints()
        setButtonAction()
        setUI()
        self.profileImageView.image = .puppyImage01
        self.dogNameLabel.text = data.dogName
        if status == .PENDING {
            self.addressLabel.text = data.dongAddress + String(format: " %.1f", data.distance) + "km"
            if record == .requested {
                self.peopleCountLabel.text = "2"
            }
        }else {
            self.addressLabel.text = data.dongAddress + " " + data.addressDetail
        }
        if record == .requested && status == .PENDING {
            seeInfoLabel.text = "지원한 산책자 보기"
        }else if record == .applied {
            seeInfoLabel.text = "지원 정보 보기"
        }else {
            seeInfoLabel.text = "산책 정보 보기"
        }
        if status == .REJECTED || status == .COMPLETED {
            seeInfoLabel.textColor = .white
        }else {
            seeInfoLabel.textColor = .gray600
        }
        if record == .requested, status != .PENDING, let walkerName = data.walkerNickname, let profile = data.walkerProfile {
            //TODO: "산책자 김도비님" 라벨 + 이미지뷰 추가
        }
        self.dateLabel.text = formatDateRange(start: data.startTime, end: data.endTime)
    }
    
    private func setButtonAction() {
        seeInfoButton.addTarget(self, action: #selector(seeInfoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func seeInfoButtonTapped() {
        delegate?.didTapMatchingStatusListCollectionViewCell(matchingResponseData: matchingData, record: record, status: status)
    }
}
