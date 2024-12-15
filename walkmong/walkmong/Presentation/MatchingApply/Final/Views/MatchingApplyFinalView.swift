//
//  MatchingApplyFinalView.swift
//  walkmong
//
//  Created by 황채웅 on 11/14/24.
//

import UIKit

protocol MatchingApplyFinalViewDelegate: AnyObject {
    func didCheckedInformation(button: UIButton)
    func didTapApplyButton()
    func didTapBackButton()
}

class MatchingApplyFinalView: UIView {
    
    weak var delegate: MatchingApplyFinalViewDelegate?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .gray100
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .gray100
        return contentView
    }()
    
    private let titleLabel = MiddleTitleLabel(text: "산책 신청 확인", textColor: .mainBlack)
    private var dogInformationView = DogProfileInformationView()
    private var walkerInformationView = BaseProfileInformationView()
    private let planTitleLabel = MiddleTitleLabel(text: "산책 일정")
    private let planStartInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let planStartLabel = CaptionLabel(text: "산책 시작", textColor: .gray400)
    private let planStartDateLabel = MainHighlightParagraphLabel(text: "시작 날짜", textColor: .mainBlue)
    private let planEndInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let planEndLabel = CaptionLabel(text: "산책 종료", textColor: .gray400)
    private let planEndDateLabel = MainHighlightParagraphLabel(text: "종료 날짜", textColor: .mainBlue)
    private let placeTitleLabel = SmallTitleLabel(text: "만남 장소")
    private let placeInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let placeAddressLabel = MainHighlightParagraphLabel(text: "주소", textColor: .gray500)
    private let placeMemoLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "스타벅스 로고 앞에서 만나요!", textColor: .gray500)
        label.numberOfLines = 5
        label.setLineSpacing(ratio: 1.4)
        label.addCharacterSpacing()
        return label
    }()
    private let stuffTitleLabel = SmallTitleLabel(text: "산책 용품 제공")
    private let stuffbackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let stuffLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "배변봉투, 입마개, 리드줄(목줄)이 필요해요.", textColor: .gray500)
        label.textAlignment = .center
        return label
    }()
    private let preMeetingTitleLabel = SmallTitleLabel(text: "사전 만남")
    private let preMeetingWarningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .warningIcon
        return imageView
    }()
    private let preMeetingWarningMessageLabel = SmallMainHighlightParagraphLabel(text: "매칭 확정 후 반려인과 상의하여 사전 만남을 진행해 주세요", textColor: .mainBlue)
    private let preMeetingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let preMeetingLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "산책일 전 사전 만남이 필요해요.", textColor: .gray500)
        label.textAlignment = .center
        return label
    }()
    
    private let messageTitleLabel = SmallTitleLabel(text: "반려인에게 전달할 메시지")
    private let messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private let messageLabel: MainParagraphLabel = {
        let label = MainParagraphLabel(text: "반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지반려인에게 전달할 메시지", textColor: .gray500)
        label.setLineSpacing(ratio: 1.4)
        label.addCharacterSpacing()
        label.numberOfLines = 10
        return label
    }()
    
    private let checkView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let checkBoxButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setImage(UIImage.checkBoxLined.imageWithColor(color: .gray300), for: .normal)
        button.setImage(UIImage.checkbox.imageWithColor(color: .mainBlue), for: .selected)
        return button
    }()
    private let checkedLabel:MainHighlightParagraphLabel = {
        let label = MainHighlightParagraphLabel(text:"반려견 정보와 작성 내용을 확인했습니다.\n(산책 지원 후 수정이 불가능합니다)", textColor: .gray500)
        label.numberOfLines = 2
        label.setLineSpacing(ratio: 1.4)
        return label
    }()
    private let nextButton = NextButton(text: "산책 지원하기")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraints()
        setButtonActions()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        addSubviews(scrollView, checkView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubviews(titleLabel,
                                      dogInformationView,
                                      walkerInformationView,
                                      planTitleLabel,
                                      planStartInformationView,
                                      planEndInformationView,
                                      placeTitleLabel,
                                      placeInformationView,
                                      placeAddressLabel,
                                      placeMemoLabel,
                                      stuffTitleLabel,
                                      stuffbackgroundView,
                                      stuffLabel,
                                      preMeetingTitleLabel,
                                      preMeetingWarningIcon,
                                      preMeetingWarningMessageLabel,
                                      preMeetingBackgroundView,
                                      preMeetingLabel,
                                      messageTitleLabel,
                                      messageBackgroundView,
                                      messageLabel)
        planStartInformationView.addSubviews(planStartLabel, planStartDateLabel)
        planEndInformationView.addSubviews(planEndLabel, planEndDateLabel)
        checkView.addSubviews(checkBoxButton,
                              checkedLabel,
                              nextButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(messageBackgroundView.snp.bottom).offset(273)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(15)
            make.leading.equalToSuperview().offset(18)
        }
        dogInformationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.height.equalTo(174)
        }
        walkerInformationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(dogInformationView.snp.bottom).offset(7)
            make.height.equalTo(178)
        }
        planTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(walkerInformationView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        planStartInformationView.snp.makeConstraints { make in
            make.top.equalTo(planTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(67)
            make.width.equalTo(scrollContentView.snp.width).multipliedBy(0.5).offset(-24)
        }
        planStartLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(9.5)
        }
        planStartDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(9.5)
        }
        planEndInformationView.snp.makeConstraints { make in            make.top.equalTo(planTitleLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(67)
            make.width.equalTo(scrollContentView.snp.width).multipliedBy(0.5).offset(-24)
        }
        planEndLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(9.5)
        }
        planEndDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(9.5)
        }
        placeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(planEndInformationView.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        placeInformationView.snp.makeConstraints { make in
            make.top.equalTo(placeTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        placeAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeInformationView.snp.top).offset(12)
            make.leading.equalTo(placeInformationView.snp.leading).offset(12)
        }
        placeMemoLabel.snp.makeConstraints { make in
            make.top.equalTo(placeAddressLabel.snp.bottom).offset(10)
            make.leading.equalTo(placeInformationView.snp.leading).offset(12)
            make.bottom.equalTo(placeInformationView.snp.bottom).inset(12)
        }
        stuffTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeInformationView.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        stuffbackgroundView.snp.makeConstraints { make in
            make.top.equalTo(stuffTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        stuffLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stuffbackgroundView.snp.centerY)
            make.horizontalEdges.equalTo(stuffbackgroundView).inset(12)
        }
        preMeetingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stuffbackgroundView.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        preMeetingWarningIcon.snp.makeConstraints { make in
            make.centerY.equalTo(preMeetingWarningMessageLabel.snp.centerY)
            make.leading.equalTo(preMeetingTitleLabel.snp.leading)
            make.width.height.equalTo(12)
        }
        preMeetingWarningMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(preMeetingTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(preMeetingTitleLabel.snp.leading).offset(16)
        }
        preMeetingBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(preMeetingWarningMessageLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        preMeetingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(preMeetingBackgroundView.snp.centerY)
            make.horizontalEdges.equalTo(preMeetingBackgroundView).inset(12)
        }
        messageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(preMeetingBackgroundView.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        messageBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(messageTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(273)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(messageBackgroundView).inset(12)
            make.bottom.equalTo(messageBackgroundView.snp.bottom).inset(12)
        }
        checkView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(213)
        }
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
        }
        checkedLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(12)
            make.centerY.equalTo(checkBoxButton.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(46)
        }
    }
    
    
    private func setButtonActions() {
        checkBoxButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setUI() {
        dogInformationView.configure(isFemale: true, name: "봄별이", informationText: "소형견 · 말티즈 · 4kg", location: "노원구 공릉동 1km", profileImage: .puppy)
        walkerInformationView.configure(name: "김철수", informationText: "30대 초반 · 남성", location: "노원구 공릉동", profileImage: .illustration1)
    }
    
    @objc private func checkBoxButtonTapped() {
        checkBoxButton.isSelected.toggle()
        nextButton.backgroundColor = checkBoxButton.isSelected ? .gray600 : .gray300
        delegate?.didCheckedInformation(button: checkBoxButton)
    }
    
    @objc private func nextButtonTapped() {
        delegate?.didTapApplyButton()
    }
}
