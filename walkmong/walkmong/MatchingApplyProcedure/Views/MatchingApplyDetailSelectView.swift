//
//  MatchingApplyDetailSelectView.swift
//  walkmong
//
//  Created by 황채웅 on 11/8/24.
//

import UIKit

class MatchingApplyDetailSelectView: UIView {
    
    //MARK: UI Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView: UIView = UIView()
    
    private let matchingDetailCheckTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "산책 내용 확인"
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        label.textColor = .gray600
        return label
    }()
    
    private let checkDogInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "반려견 정보를 확인했나요?"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .gray600
        return label
    }()
    
    private let checkDogInformationNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니오", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let checkDogInformationYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let checkDateLabel: UILabel = {
        let label = UILabel()
        label.text = "산책 일정에 산책이 가능한가요?"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .gray600
        return label
    }()
    
    private let selectDateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let calendarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .calendarIcon
        return imageView
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "산책 일정"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let calendarStartLabel: UILabel = {
        let label = UILabel()
        label.text = "시작"
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .gray400
        return label
    }()
    
    private let calendarEndLabel: UILabel = {
        let label = UILabel()
        label.text = "종료"
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .gray400
        return label
    }()
    
    private let calendarStartDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024.10.25 (금) 16:00"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .gray600
        return label
    }()
    
    private let calendarEndDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024.10.25 (금) 16:30"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .gray600
        return label
    }()
    
    private let checkDateNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니오", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let checkDateYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let selectPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 만남 장소를 선택해주세요."
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .gray600
        return label
    }()
    
    private let selectPlaceWarningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .warningIcon
        return imageView
    }()
    
    private let selectPlaceWarningMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "장소 선택 후 반려인과 상의하여 장소를 변경해도 괜찮아요!"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .mainBlue
        return label
    }()
    
    //TODO: 선택한 장소에 따라 UI 업데이트
    private let selectedPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "강남구 학동로 508"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .gray
        return label
    }()
    
    private let selectPlaceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let placeSelectButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "장소 선택하기"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let placeSelectButtonArrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowRight
        return imageView
    }()
    
    private let selectStuffNeededLabel: UILabel = {
        let label = UILabel()
        label.text = "산책 용품 제공이 필요한가요?"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .gray600
        return label
    }()
    
    private let poopEnvelopeLabel: UILabel = {
        let label = UILabel()
        label.text = "배변봉투"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let poopEnvelopeNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("괜찮아요", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let poopEnvelopeYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("필요해요", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let mouthCoverLabel: UILabel = {
        let label = UILabel()
        label.text = "입마개"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let mouthCoverNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("괜찮아요", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let mouthCoverYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("필요해요", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let leadStringLabel: UILabel = {
        let label = UILabel()
        label.text = "리드줄(목줄)"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let leadStringNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("괜찮아요", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let leadStringYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("필요해요", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let selectPreMeetingLabel: UILabel = {
        let label = UILabel()
        label.text = "사전 만남을 진행하고 싶으신가요?"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .gray600
        return label
    }()
    
    private let selectPreMeetingWarningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .warningIcon
        return imageView
    }()
    
    private let selectPreMeetingWarningMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "산책 진행 전 사전 만남이 필요하면 예를 눌러주세요"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .mainBlue
        return label
    }()
    
    private let selectPreMeetingNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니오", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let selectPreMeetingYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 15
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        addSubviews(
            scrollView,
            nextButton)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubviews(
            matchingDetailCheckTitleLabel,
            checkDogInformationLabel,
            checkDogInformationNoButton,
            checkDogInformationYesButton,
            checkDateLabel,
            selectDateBackgroundView,
            checkDateNoButton,
            checkDateYesButton,
            selectPlaceLabel,
            selectPlaceWarningIcon,
            selectPlaceWarningMessageLabel,
            selectPlaceButton,
            placeSelectButtonLabel,
            placeSelectButtonArrowIcon,
            selectStuffNeededLabel,
            poopEnvelopeLabel,
            poopEnvelopeNoButton,
            poopEnvelopeYesButton,
            mouthCoverLabel,
            mouthCoverNoButton,
            mouthCoverYesButton,
            leadStringLabel,
            leadStringNoButton,
            leadStringYesButton,
            selectPreMeetingLabel,
            selectPreMeetingWarningIcon,
            selectPreMeetingWarningMessageLabel,
            selectPreMeetingNoButton,
            selectPreMeetingYesButton)
        
        selectDateBackgroundView.addSubviews(
            calendarIcon,
            calendarLabel,
            calendarStartLabel,
            calendarEndLabel,
            calendarStartDateLabel,
            calendarEndDateLabel)
        
        selectPlaceButton.addSubviews(
            placeSelectButtonLabel,
            placeSelectButtonArrowIcon)
    }
    
    private func setConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(selectPreMeetingNoButton.snp.bottom).offset(161)
        }
        
        matchingDetailCheckTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(18)
        }
        
        checkDogInformationLabel.snp.makeConstraints { make in
            make.top.equalTo(matchingDetailCheckTitleLabel.snp.bottom).offset(23)
            make.leading.equalToSuperview().offset(20)
        }
        
        checkDogInformationYesButton.snp.makeConstraints { make in
            make.top.equalTo(checkDogInformationLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(46)
            make.height.equalTo(38)
        }
        
        checkDogInformationNoButton.snp.makeConstraints { make in
            make.top.equalTo(checkDogInformationLabel.snp.bottom).offset(20)
            make.trailing.equalTo(checkDogInformationYesButton.snp.leading).offset(-12)
            make.width.equalTo(73)
            make.height.equalTo(38)
        }
        
        checkDateLabel.snp.makeConstraints { make in
            make.top.equalTo(checkDogInformationYesButton.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        
        selectDateBackgroundView.snp.makeConstraints{ make in
            make.top.equalTo(checkDateLabel.snp.bottom).offset(20)
            make.height.equalTo(74)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        checkDateYesButton.snp.makeConstraints { make in
            make.top.equalTo(selectDateBackgroundView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(46)
            make.height.equalTo(38)
        }
        
        checkDateNoButton.snp.makeConstraints { make in
            make.top.equalTo(selectDateBackgroundView.snp.bottom).offset(20)
            make.trailing.equalTo(checkDateYesButton.snp.leading).offset(-12)
            make.width.equalTo(73)
            make.height.equalTo(38)
        }
        
        selectPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(checkDateNoButton.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        
        selectPlaceWarningIcon.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.leading.equalTo(selectPlaceLabel.snp.leading)
            make.centerY.equalTo(selectPlaceWarningMessageLabel.snp.centerY)
        }
        
        selectPlaceWarningMessageLabel.snp.makeConstraints{ make in
            make.top.equalTo(selectPlaceLabel.snp.bottom).offset(8)
            make.leading.equalTo(selectPlaceWarningIcon.snp.trailing).offset(4)
        }
        
        selectPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(selectPlaceLabel.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }
        
        selectStuffNeededLabel.snp.makeConstraints { make in
            make.top.equalTo(selectPlaceButton.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        
        poopEnvelopeLabel.snp.makeConstraints { make in
            make.top.equalTo(selectStuffNeededLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        poopEnvelopeYesButton.snp.makeConstraints { make in
            make.centerY.equalTo(poopEnvelopeLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(87)
            make.height.equalTo(38)
        }
        
        poopEnvelopeNoButton.snp.makeConstraints { make in
            make.centerY.equalTo(poopEnvelopeLabel.snp.centerY)
            make.width.equalTo(87)
            make.height.equalTo(38)
            make.trailing.equalTo(poopEnvelopeYesButton.snp.leading).offset(-12)
        }
        
        mouthCoverLabel.snp.makeConstraints { make in
            make.top.equalTo(poopEnvelopeLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
        
        mouthCoverYesButton.snp.makeConstraints { make in
            make.centerY.equalTo(mouthCoverLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(87)
            make.height.equalTo(38)
        }
        
        mouthCoverNoButton.snp.makeConstraints { make in
            make.centerY.equalTo(mouthCoverLabel.snp.centerY)
            make.width.equalTo(87)
            make.height.equalTo(38)
            make.trailing.equalTo(mouthCoverYesButton.snp.leading).offset(-12)
        }
        
        leadStringLabel.snp.makeConstraints { make in
            make.top.equalTo(mouthCoverLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
        
        leadStringYesButton.snp.makeConstraints { make in
            make.centerY.equalTo(leadStringLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(87)
            make.height.equalTo(38)
        }
        
        leadStringNoButton.snp.makeConstraints { make in
            make.centerY.equalTo(leadStringLabel.snp.centerY)
            make.width.equalTo(87)
            make.height.equalTo(38)
            make.trailing.equalTo(leadStringYesButton.snp.leading).offset(-12)
        }
        
        selectPreMeetingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(leadStringLabel.snp.bottom).offset(56)
        }
        
        selectPreMeetingWarningIcon.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.leading.equalTo(selectPreMeetingLabel.snp.leading)
            make.centerY.equalTo(selectPreMeetingWarningMessageLabel.snp.centerY)
        }
        
        selectPreMeetingWarningMessageLabel.snp.makeConstraints{ make in
            make.top.equalTo(selectPreMeetingLabel.snp.bottom).offset(8)
            make.leading.equalTo(selectPreMeetingWarningIcon.snp.trailing).offset(4)
        }
        
        selectPreMeetingYesButton.snp.makeConstraints { make in
            make.top.equalTo(selectPreMeetingWarningMessageLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(46)
            make.height.equalTo(38)
        }
        
        selectPreMeetingNoButton.snp.makeConstraints { make in
            make.top.equalTo(selectPreMeetingWarningMessageLabel.snp.bottom).offset(16)
            make.trailing.equalTo(selectPreMeetingYesButton.snp.leading).offset(-12)
            make.width.equalTo(73)
            make.height.equalTo(38)
        }
        
        calendarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(42)
        }
        
        calendarIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalTo(calendarLabel.snp.centerY)
            make.leading.equalToSuperview().inset(16)
        }
        
        calendarStartLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarStartDateLabel.snp.centerY)
            make.trailing.equalTo(calendarStartDateLabel.snp.leading).offset(-8)
        }
        
        calendarStartDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(11)
            make.top.equalToSuperview().inset(16.5)
        }
        
        calendarEndLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarEndDateLabel.snp.centerY)
            make.trailing.equalTo(calendarEndDateLabel.snp.leading).offset(-8)
        }
        
        calendarEndDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(11)
            make.top.equalTo(calendarStartDateLabel.snp.bottom).offset(4)
        }
        
        placeSelectButtonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        placeSelectButtonArrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
}
