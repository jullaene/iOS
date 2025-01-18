//
//  MatchingStatusWalkInfoForOwnerView.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit
import NMapsMap

protocol MatchingStatusWalkInfoForOwnerViewDelegate: AnyObject {
    func didTapWalkTalkButton()
    func didTapApplyButton()
}

final class MatchingStatusWalkInfoForOwnerView: UIView {
        
    weak var delegate: MatchingStatusWalkInfoForOwnerViewDelegate?

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dogProfileView = UIView()
    
    private let applicantInfoLabel = SmallTitleLabel(text: "산책자 정보", textColor: .gray600)
    private let applicantInfoCell = MatchingStatusApplicantDetailCell()
    
    private let preMeeting: UIView = CustomView.createCustomView(
        titleText: "사전 만남",
        contentText: "2024.10.23 (수) 16:00",
        contentTextAlignment: .center
    )
    
    private let meetingPlaceTitle = SmallTitleLabel(text: "만남 장소")
    private let meetingPlaceView = UIView.createRoundedView(backgroundColor: .white, cornerRadius: 10)
    private let locationIcon = UIImage.createImageView(named: "locationIcon", tintColor: .gray600)
    private let locationLabel = MainParagraphLabel(text: "강남구 학동로 508", textColor: .gray600)
    private let sendMessage: UIView = CustomView.createCustomView(
        titleText: "산책인이 전달한 메시지",
        contentText: "우리 멍멍이 귀여워요",
        contentTextColor: .gray500,
        contentTextAlignment: .center
    )
    private let locationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "스타벅스 로고 앞에서 만나요!"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hexCode: "#444444")
        return label
    }()
    private let mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        return mapView
    }()
    private let mapBlockerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let centerMarker: CustomMarker = {
        let marker = CustomMarker()
        marker.height = 60
        marker.width = 47
        return marker
    }()
    private let walkItemTitle = SmallTitleLabel(text: "산책 준비물")
    private let walkItemleadLineButton = UIButton.createStyledButton(type: .largeSelectionCheck, style: .light, title: "리드줄(목줄)")
    private let walkItemleadPoopBagButton = UIButton.createStyledButton(type: .largeSelectionCheck, style: .light, title: "배변봉투")
    private let walkItemleadMuzzleButton = UIButton.createStyledButton(type: .largeSelectionCheck, style: .light, title: "입마개")

    private var isLeadLineButtonDark = false
    private var isPoopBagButtonDark = false
    private var isMuzzleButtonDark = false
    
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
        setupButtonActions()
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
        
        contentView.addSubview(dogProfileView)
        dogProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(187)
        }
        
        contentView.addSubview(applicantInfoLabel)
        applicantInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dogProfileView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        applicantInfoCell.backgroundColor = .white
        applicantInfoCell.layer.cornerRadius = 10
        applicantInfoCell.layer.masksToBounds = true
        contentView.addSubview(applicantInfoCell)
        applicantInfoCell.snp.makeConstraints { make in
            make.top.equalTo(applicantInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(preMeeting)
        preMeeting.snp.makeConstraints { make in
            make.top.equalTo(applicantInfoCell.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(meetingPlaceTitle)
        meetingPlaceTitle.snp.makeConstraints { make in
            make.top.equalTo(preMeeting.snp.bottom).offset(48)
            make.leading.equalTo(20)
        }
        contentView.addSubview(meetingPlaceView)
        meetingPlaceView.snp.makeConstraints { make in
            make.top.equalTo(meetingPlaceTitle.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        meetingPlaceView.addSubviews(locationIcon, locationLabel, locationDescriptionLabel, mapView, mapBlockerView)
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
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(mapView.snp.width)
            make.bottom.equalToSuperview().inset(12)
        }
        
        mapBlockerView.snp.makeConstraints { make in
            make.top.equalTo(locationDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(mapView.snp.width)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(sendMessage)
        sendMessage.snp.makeConstraints { make in
            make.top.equalTo(meetingPlaceView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubviews(walkItemTitle, walkItemleadLineButton, walkItemleadPoopBagButton, walkItemleadMuzzleButton)
        walkItemTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sendMessage.snp.bottom).offset(48)
        }
        walkItemleadLineButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(walkItemTitle.snp.bottom).offset(24)
            make.height.equalTo(46)
        }
        walkItemleadPoopBagButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(walkItemleadLineButton.snp.bottom).offset(12)
            make.height.equalTo(46)
        }
        walkItemleadMuzzleButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(walkItemleadPoopBagButton.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(43)
            make.height.equalTo(46)
        }
        
        setupInitialButtonStyle(walkItemleadLineButton)
        setupInitialButtonStyle(walkItemleadPoopBagButton)
        setupInitialButtonStyle(walkItemleadMuzzleButton)
        setupWalkItemButtons()
        
    }
    
    // MARK: - 데이터 설정
    func updateDogProfile(with data: BoardList) {

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
    
    func configureApplicantsList(with applicant: MatchingStatusApplicantInfo) {
        setupApplicantInfoCell(with: applicant)
    }
    
    private func setupApplicantInfoCell(with applicant: MatchingStatusApplicantInfo) {
        
        applicantInfoCell.updateOwnerInfo(
            ownerProfile: applicant.ownerProfile ?? "defaultProfileImage",
            ownerName: applicant.ownerName,
            ownerAge: applicant.ownerAge,
            ownerGender: applicant.ownerGender,
            dongAddress: applicant.dongAddress,
            distance: applicant.distance
        )
    }
    
    private func setupWalkItemButtons() {
        walkItemleadLineButton.addTarget(self, action: #selector(didTapLeadLineButton), for: .touchUpInside)
        walkItemleadPoopBagButton.addTarget(self, action: #selector(didTapPoopBagButton), for: .touchUpInside)
        walkItemleadMuzzleButton.addTarget(self, action: #selector(didTapMuzzleButton), for: .touchUpInside)
    }

    @objc private func didTapLeadLineButton() {
        isLeadLineButtonDark.toggle()
        if isLeadLineButtonDark {
            walkItemleadLineButton.backgroundColor = .mainBlue
            walkItemleadLineButton.setTitleColor(.white, for: .normal)
        } else {
            walkItemleadLineButton.backgroundColor = .white
            walkItemleadLineButton.setTitleColor(.gray500, for: .normal)
        }
    }

    @objc private func didTapPoopBagButton() {
        isPoopBagButtonDark.toggle()
        if isPoopBagButtonDark {
            walkItemleadPoopBagButton.backgroundColor = .mainBlue
            walkItemleadPoopBagButton.setTitleColor(.white, for: .normal)
        } else {
            walkItemleadPoopBagButton.backgroundColor = .white
            walkItemleadPoopBagButton.setTitleColor(.gray500, for: .normal)
        }
    }

    @objc private func didTapMuzzleButton() {
        isMuzzleButtonDark.toggle()
        if isMuzzleButtonDark {
            walkItemleadMuzzleButton.backgroundColor = .mainBlue
            walkItemleadMuzzleButton.setTitleColor(.white, for: .normal)
        } else {
            walkItemleadMuzzleButton.backgroundColor = .white
            walkItemleadMuzzleButton.setTitleColor(.gray500, for: .normal)
        }
    }
    
    private func setupInitialButtonStyle(_ button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(.gray500, for: .normal)
    }
    
    func setupMap(initialPosition: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialPosition, zoomTo: 15)
        mapView.mapView.moveCamera(cameraUpdate)
        mapView.showScaleBar = false
        mapView.showZoomControls = false
        mapView.isUserInteractionEnabled = false
        centerMarker.position = initialPosition
        centerMarker.mapView = mapView.mapView
    }
    
    private func setupButtonActions() {
        let tapGesture = UITapGestureRecognizer(target: self.walkTalkButton, action: #selector(didTapWalkTalkButton))
        self.walkTalkButton.addGestureRecognizer(tapGesture)
        applyWalkButton.addTarget(self, action: #selector(didTapApplyWalkButton), for: .touchUpInside)
    }
    
    @objc private func didTapWalkTalkButton() {
        delegate?.didTapWalkTalkButton()
    }
    
    @objc private func didTapApplyWalkButton() {
        delegate?.didTapApplyButton()
    }
}
