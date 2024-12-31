//
//  MatchingApplyDetailSelectView.swift
//  walkmong
//
//  Created by 황채웅 on 11/8/24.
//

import UIKit

protocol MatchingApplyDetailSelectViewDelegate: AnyObject {
    func buttonTapped(buttonType: ButtonType, value: Bool)
    func updatePlaceSelected(_ view: MatchingApplyDetailSelectView,_ model: MatchingApplyMapModel)
}

enum ButtonType{
    case dogInformationChecked, dateChecked, selectPlace, envelopeNeeded, mouthCoverNeeded, leadStringeNeeded, preMeetingNeeded, next
}

class MatchingApplyDetailSelectView: UIView {
    
    private var dogInformationChecked: Bool = false
    private var dateChecked: Bool = false
    private var placeSelected: Bool = false
    private var envelopeNeeded: Bool?
    private var mouthCoverNeeded: Bool?
    private var leadStringeNeeded: Bool?
    private var preMeetingNeeded: Bool?
    
    weak var delegate: MatchingApplyDetailSelectViewDelegate?
    
    //MARK: UI Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView: UIView = UIView()
    
    private let matchingDetailCheckTitleLabel = MiddleTitleLabel(text: "산책 내용 확인", textColor: .gray600)
    
    private let checkDogInformationLabel = SmallTitleLabel(text: "반려견 정보를 확인했나요?", textColor: .gray600)
    
    private let checkDogInformationNoButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니오", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let checkDogInformationYesButton: UIButton = {
        let button = UIButton()
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 38/2
        return button
    }()
    
    private let checkDateLabel = SmallTitleLabel(text: "산책 일정에 산책이 가능한가요?", textColor: .gray600)
    
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
    
    private let calendarStartLabel = CaptionLabel(text: "시작", textColor: .gray400)
    
    private let calendarEndLabel: UILabel = CaptionLabel(text: "종료", textColor: .gray400)
    
    private let calendarStartDateLabel = SmallMainHighlightParagraphLabel(text: "2024.10.25 (금) 16:00", textColor: .gray600)
    
    private let calendarEndDateLabel = SmallMainHighlightParagraphLabel(text: "2024.10.25 (금) 16:30", textColor: .gray600)
    
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
    
    private let selectPlaceLabel = SmallTitleLabel(text: "원하는 만남 장소를 선택해주세요.", textColor: .gray600)
    
    private let selectPlaceWarningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .warningIconMainBlue
        return imageView
    }()
    
    private let selectPlaceWarningMessageLabel = SmallMainHighlightParagraphLabel(text: "장소 선택 후 반려인과 상의하여 장소를 변경해도 괜찮아요!", textColor: .gray600)
    
    //TODO: 선택한 장소에 따라 UI 업데이트
    private let selectedPlaceLabel = SmallTitleLabel(text: "강남구 학동로 508", textColor: .gray600)
    
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
    
    private let selectStuffNeededLabel = SmallTitleLabel(text: "산책 용품 제공이 필요한가요?", textColor: .gray600)
    
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
    
    private let selectPreMeetingLabel = SmallTitleLabel(text: "사전 만남을 진행하고 싶으신가요?", textColor: .gray600)
    
    private let selectPreMeetingWarningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .warningIconMainBlue
        return imageView
    }()
    
    private let selectPreMeetingWarningMessageLabel = SmallMainHighlightParagraphLabel(text: "산책 진행 전 사전 만남이 필요하면 예를 눌러주세요", textColor: .mainBlue)
    
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
    
    private let addressLabel = SmallTitleLabel(text: "선택한 주소")
    
    private let placeMemoLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "메모", textColor: .gray500)
        label.setLineSpacing(ratio: 1.4)
        label.addCharacterSpacing()
        label.numberOfLines = 10
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
        addButtonTargets()
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
            selectPreMeetingYesButton,
            addressLabel)
        
        selectDateBackgroundView.addSubviews(
            calendarIcon,
            calendarLabel,
            calendarStartLabel,
            calendarEndLabel,
            calendarStartDateLabel,
            calendarEndDateLabel)
        
        selectPlaceButton.addSubviews(
            placeSelectButtonLabel,
            placeSelectButtonArrowIcon,
            placeMemoLabel)
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
        
        if placeSelected {
            addressLabel.snp.remakeConstraints { make in
                make.top.equalTo(selectPlaceLabel.snp.bottom).offset(48)
                make.horizontalEdges.equalToSuperview().inset(20)
            }
            
        }else {
            placeSelectButtonLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
            }
            placeSelectButtonArrowIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
                make.height.width.equalTo(16)
            }
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    private func addButtonTargets() {
        selectPlaceButton.addTarget(self, action: #selector (selectPlaceButtonTapped), for: .touchUpInside)
        checkDogInformationNoButton.addTarget(self, action: #selector(checkDogInformationNoButtonTapped), for: .touchUpInside)
        checkDogInformationYesButton.addTarget(self, action: #selector(checkDogInformationYesButtonTapped), for: .touchUpInside)
        checkDateNoButton.addTarget(self, action: #selector(checkDateNoButtonTapped), for: .touchUpInside)
        checkDateYesButton.addTarget(self, action: #selector(checkDateYesButtonTapped), for: .touchUpInside)
        poopEnvelopeNoButton.addTarget(self, action: #selector(poopEnvelopeNoButtonTapped), for: .touchUpInside)
        poopEnvelopeYesButton.addTarget(self, action: #selector(poopEnvelopeYesButtonTapped), for: .touchUpInside)
        mouthCoverNoButton.addTarget(self, action: #selector(mouthCoverNoButtonTapped), for: .touchUpInside)
        mouthCoverYesButton.addTarget(self, action: #selector(mouthCoverYesButtonTapped), for: .touchUpInside)
        leadStringNoButton.addTarget(self, action: #selector(leadStringNoButtonTapped), for: .touchUpInside)
        leadStringYesButton.addTarget(self, action: #selector(leadStringYesButtonTapped), for: .touchUpInside)
        selectPreMeetingNoButton.addTarget(self, action: #selector(preMeetingNeededNoButtonTapped), for: .touchUpInside)
        selectPreMeetingYesButton.addTarget(self, action: #selector(preMeetingNeededYesButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    
    @objc func checkDogInformationNoButtonTapped() {
        delegate?.buttonTapped(buttonType: .dogInformationChecked, value: false)
    }
    
    @objc func checkDogInformationYesButtonTapped() {
        delegate?.buttonTapped(buttonType: .dogInformationChecked, value: true)
    }
    
    @objc func checkDateNoButtonTapped() {
        delegate?.buttonTapped(buttonType: .dateChecked, value: false)
    }
    
    @objc func checkDateYesButtonTapped() {
        delegate?.buttonTapped(buttonType: .dateChecked, value: true)
    }
    
    @objc func selectPlaceButtonTapped() {
        delegate?.buttonTapped(buttonType: .selectPlace, value: true)
    }
    
    @objc func poopEnvelopeNoButtonTapped() {
        delegate?.buttonTapped(buttonType: .envelopeNeeded, value: false)
    }
    
    @objc func poopEnvelopeYesButtonTapped() {
        delegate?.buttonTapped(buttonType: .envelopeNeeded, value: true)
    }
    
    @objc func mouthCoverNoButtonTapped() {
        delegate?.buttonTapped(buttonType: .mouthCoverNeeded, value: false)
    }
    
    @objc func mouthCoverYesButtonTapped() {
        delegate?.buttonTapped(buttonType: .mouthCoverNeeded, value: true)
    }
    
    @objc func leadStringNoButtonTapped() {
        delegate?.buttonTapped(buttonType: .leadStringeNeeded, value: false)
    }
    
    @objc func leadStringYesButtonTapped() {
        delegate?.buttonTapped(buttonType: .leadStringeNeeded, value: true)
    }
    
    @objc func preMeetingNeededNoButtonTapped() {
        delegate?.buttonTapped(buttonType: .preMeetingNeeded, value: false)
    }
    
    @objc func preMeetingNeededYesButtonTapped() {
        delegate?.buttonTapped(buttonType: .preMeetingNeeded, value: true)
    }
    
    @objc func nextButtonTapped() {
        delegate?.buttonTapped(buttonType: .next, value: true)
    }
    
    func updateSelectButtons(buttonType: ButtonType, value: Bool,_ data: MatchingApplyMapModel?) {
        switch buttonType {
        case .dogInformationChecked:
            updateButtonColors(selectedButton: value ? checkDogInformationYesButton : checkDogInformationNoButton,
                               unselectedButton: value ? checkDogInformationNoButton : checkDogInformationYesButton)
            
        case .dateChecked:
            updateButtonColors(selectedButton: value ? checkDateYesButton : checkDateNoButton,
                               unselectedButton: value ? checkDateNoButton : checkDateYesButton)
            
        case .selectPlace:
            if let data = data {
                updatePlace(data: data)
            }
            
        case .envelopeNeeded:
            updateButtonColors(selectedButton: value ? poopEnvelopeYesButton : poopEnvelopeNoButton,
                               unselectedButton: value ? poopEnvelopeNoButton : poopEnvelopeYesButton)
            
        case .mouthCoverNeeded:
            updateButtonColors(selectedButton: value ? mouthCoverYesButton : mouthCoverNoButton,
                               unselectedButton: value ? mouthCoverNoButton : mouthCoverYesButton)
            
        case .leadStringeNeeded:
            updateButtonColors(selectedButton: value ? leadStringYesButton : leadStringNoButton,
                               unselectedButton: value ? leadStringNoButton : leadStringYesButton)
            
        case .preMeetingNeeded:
            updateButtonColors(selectedButton: value ? selectPreMeetingYesButton : selectPreMeetingNoButton,
                               unselectedButton: value ? selectPreMeetingNoButton : selectPreMeetingYesButton)
        case .next:
            nextButton.backgroundColor = value ? .gray600 : .gray300
        }
    }

    private func updateButtonColors(selectedButton: UIButton, unselectedButton: UIButton) {
        selectedButton.backgroundColor = .mainBlue
        selectedButton.setTitleColor(.white, for: .normal)
        
        unselectedButton.backgroundColor = .gray100
        unselectedButton.setTitleColor(.gray500, for: .normal)
    }
    
    private func updatePlace(data: MatchingApplyMapModel){
        addressLabel.text = data.roadAddress
        placeMemoLabel.text = data.memo
        addressLabel.snp.remakeConstraints { make in
            make.top.equalTo(selectPlaceLabel.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        selectPlaceButton.snp.remakeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        placeMemoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(12)
        }
        placeSelectButtonLabel.removeFromSuperview()
        placeSelectButtonArrowIcon.removeFromSuperview()
    }
}
