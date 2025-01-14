//
//  MatchingStatusMyApplicationView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusMyApplicationView: UIView {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView = UIView()
    
    private let meetingPlace: UIView = CustomView.createCustomView(
        titleText: "만남 장소",
        centerLabelText: "강남구 학동로 508",
        contentText: "스타벅스 로고 앞에서 만나요!",
        layoutOption: .centerAndLeftAligned
    )
    private let walkSuppliesProvided: UIView = CustomView.createCustomView(
        titleText: "산책 용품 제공",
        contentText: "배변봉투, 입마개, 리드줄(목줄)이 필요해요."
    )
    private let preMeeting: UIView = CustomView.createCustomView(
        titleText: "사전 만남",
        warningText: "매칭 확정 후 산책자와 상의하여 사전 만남을 진행해 주세요",
        warningColor: .mainBlue,
        contentText: "산책일 전 사전 만남이 필요해요."
    )
    private let sendMessage: UIView = CustomView.createCustomView(
        titleText: "반려인에게 전달할 메시지",
        contentText: "저 열심히 산책 시킬 수 있습니다!! 강아지를 좋아해서 꼭 산책시키고 싶어요. 책임지고 열심히 임할 수 있습니다 꼭 시켜주세요!!!!!!",
        contentTextColor: .gray500,
        layoutOption: .leftAlignedContent
    )
    
    private let buttonFrame = UIView()
    private let walkTalkButton = CustomButtonView(
        backgroundColor: UIColor.gray200,
        cornerRadius: 15,
        text: "워크톡",
        textColor: UIColor.gray400,
        iconName: "messageIcon"
    )
    private let applyWalkButton = UIButton.createStyledButton(type: .large, style: .dark, title: "지원 취소")

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
        
        dogProfileView.backgroundColor = .white
        dogProfileView.layer.cornerRadius = 10
        dogProfileView.layer.masksToBounds = true
        
        contentView.addSubviews(dogProfileView, meetingPlace, walkSuppliesProvided, preMeeting, sendMessage)
        
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(187)
        }
        
        meetingPlace.snp.makeConstraints { make in
            make.top.equalTo(dogProfileView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        walkSuppliesProvided.snp.makeConstraints { make in
            make.top.equalTo(meetingPlace.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        preMeeting.snp.makeConstraints { make in
            make.top.equalTo(walkSuppliesProvided.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        sendMessage.snp.makeConstraints { make in
            make.top.equalTo(preMeeting.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(43)
        }
    }
    
    // MARK: - 데이터 설정
    func updateDogProfile(with data: BoardList) {
        dogProfileView.backgroundColor = .white
        dogProfileView.layer.cornerRadius = 10
        
        let dogProfileCell = MatchingCell()
        dogProfileCell.configure(with: data, selectedDate: "수정")
        dogProfileCell.setCustomViewAppearance(
            hideSizeLabel: true,
            backgroundColor: .clear
        )
        dogProfileView.addSubview(dogProfileCell)
        dogProfileCell.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
}
