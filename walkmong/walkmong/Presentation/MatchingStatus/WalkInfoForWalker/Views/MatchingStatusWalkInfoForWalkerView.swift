//
//  MatchingStatusWalkInfoForWalkerView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusWalkInfoForWalkerView: UIView {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView = UIView()
    
    private let preMeeting: UIView = CustomView.createCustomView(
        titleText: "사전 만남",
        contentText: "2024.10.23 (수) 16:00",
        contentTextAlignment: .center
    )
    
    private let walkRequestTitle = SmallTitleLabel(text: "산책 요청 사항")
    private let walkRequestView = UIView.createRoundedView(backgroundColor: .white, cornerRadius: 20)
    private let requestTitleLabel = MainHighlightParagraphLabel(text: "산책 요청 사항", textColor: .gray600)
    private let requestDescriptionLabel = MainParagraphLabel(text: "산책 요청 사항 상세", textColor: .gray500)
    private let referenceTitleLabel = MainHighlightParagraphLabel(text: "산책 참고 사항", textColor: .gray600)
    private let referenceDescriptionLabel = MainParagraphLabel(text: "산책 참고 사항 상세", textColor: .gray500)
    private let additionalInfoTitleLabel = MainHighlightParagraphLabel(text: "추가 안내 사항", textColor: .gray600)
    private let additionalInfoDescriptionLabel = MainParagraphLabel(text: "추가 안내 사항 상세", textColor: .gray500)
    private let meetingPlaceTitle = SmallTitleLabel(text: "만남 장소")
    private let meetingPlaceView = UIView.createRoundedView(backgroundColor: .white, cornerRadius: 10)
    private let locationIcon = UIImage.createImageView(named: "locationIcon", tintColor: .gray600)
    private let locationLabel = MainParagraphLabel(text: "강남구 학동로 508", textColor: .gray600)
    private let locationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "스타벅스 로고 앞에서 만나요!"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hexCode: "#444444")
        return label
    }()
    private let mapView = UIView.createRoundedView(backgroundColor: .red, cornerRadius: 15)

    private let buttonFrame = UIView()
    private let walkTalkButton = CustomButtonView(
        backgroundColor: UIColor.gray200,
        cornerRadius: 15,
        text: "워크톡",
        textColor: UIColor.gray400,
        iconName: "messageIcon"
    )
    private let applyWalkButton = UIButton.createStyledButton(type: .large, style: .dark, title: "매칭 취소")
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubviews(scrollView, buttonFrame)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0))
        }
        
        buttonFrame.backgroundColor = .gray100
        buttonFrame.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(78)
        }
        
        buttonFrame.addSubviews(walkTalkButton, applyWalkButton)
        walkTalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(buttonFrame.snp.leading).offset(20)
            make.width.equalTo(93)
            make.height.equalTo(54)
        }
        applyWalkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(walkTalkButton.snp.trailing).offset(12)
            make.trailing.equalTo(buttonFrame.snp.trailing).inset(17)
            make.height.equalTo(54)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(dogProfileView)
        dogProfileView.backgroundColor = .white
        dogProfileView.layer.cornerRadius = 10
        dogProfileView.layer.masksToBounds = true
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(187)
        }
        
        contentView.addSubview(preMeeting)
        preMeeting.snp.makeConstraints { make in
            make.top.equalTo(dogProfileView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(walkRequestTitle)
        walkRequestTitle.snp.makeConstraints { make in
            make.top.equalTo(preMeeting.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(walkRequestView)
        walkRequestView.snp.makeConstraints { make in
            make.top.equalTo(walkRequestTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        walkRequestView.addSubviews(requestTitleLabel, requestDescriptionLabel, referenceTitleLabel, referenceDescriptionLabel, additionalInfoTitleLabel, additionalInfoDescriptionLabel)
        
        requestTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        requestDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(requestTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        referenceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(requestDescriptionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        referenceDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(referenceTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        additionalInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(referenceDescriptionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        additionalInfoDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(additionalInfoTitleLabel.snp.bottom).offset(8)
            make.bottom.leading.trailing.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(meetingPlaceTitle)
        meetingPlaceTitle.snp.makeConstraints { make in
            make.top.equalTo(walkRequestView.snp.bottom).offset(24)
            make.leading.equalTo(20)
        }
        contentView.addSubview(meetingPlaceView)
        meetingPlaceView.snp.makeConstraints { make in
            make.top.equalTo(meetingPlaceTitle.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(43)
        }
        
        meetingPlaceView.addSubviews(locationIcon, locationLabel, locationDescriptionLabel, mapView)
        locationIcon.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel)
            make.leading.equalToSuperview().offset(12)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
        }
        
        locationDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(12)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(locationDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(mapView.snp.width)
        }
    }
    
    // MARK: - 데이터 설정
    func updateDogProfile(with data: MatchingData) {
        
        let dogProfileCell = MatchingCell()
        dogProfileCell.configure(with: data)
        dogProfileCell.setCustomViewAppearance(
            hideSizeLabel: true,
            hideDistanceLabel: true,
            hideTimeLabel: true,
            backgroundColor: .clear
        )
        dogProfileView.addSubview(dogProfileCell)
        dogProfileCell.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
}
