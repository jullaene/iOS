//
//  SignupDetailView.swift
//  walkmong
//
//  Created by 황채웅 on 1/1/25.
//

import UIKit
import SnapKit

protocol SignupDetailViewDelegate: AnyObject {
    func shouldCheckNickname(_ textfield: UITextField)
    func didTapNextButton(_ view: SignupDetailView)
    func didTapPlaceSelectButton(_ view: SignupDetailView)
}

class SignupDetailView: UIView {
    
    private var name: String = ""
    private var didSetGender: Bool = false
    private var isMale: Bool = false
    private var birthday: String = ""
    private var number: String = ""
    private var nickname: String = ""
    private var place: String = ""
    private var latitude: Double = 0
    private var longtitude: Double = 0
    
    private var errorMessage: String = ""
    
    weak var delegate: SignupDetailViewDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
    private let nameLabel = MiddleTitleLabel(text: "이름을 입력해주세요.")
    private let nameTextField = TextField(placeHolderText: "본명을 입력해주세요", keyboardType: .namePhonePad, shouldHideText: false, textContentType: .name, useCustomDelegate: true)
    
    private let genderLabel = MiddleTitleLabel(text: "성별을 선택해주세요.")
    private let maleButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "남")
    private let femaleButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "여")
    
    private let birthdayLabel = MiddleTitleLabel(text: "생년월일을 입력해주세요.")
    /// iOS 버전에 따라 분기하여 처리
    private let yearTextField = TextField(placeHolderText: "0000", keyboardType: .numberPad, shouldHideText: false, textContentType: nil, useCustomDelegate: true)
    private let yearLabel = MainParagraphLabel(text: "년")
    private let monthTextField = TextField(placeHolderText: "00", keyboardType: .numberPad, shouldHideText: false, textContentType: nil, useCustomDelegate: true)
    private let monthLabel = MainParagraphLabel(text: "월")
    private let dayTextField = TextField(placeHolderText: "00", keyboardType: .numberPad, shouldHideText: false, textContentType: nil, useCustomDelegate: true)
    private let dayLabel = MainParagraphLabel(text: "일")
    
    private let phoneNumberLabel = MiddleTitleLabel(text: "전화번호를 입력해주세요.")
    private let firstNumberTextField = TextField(placeHolderText: "", keyboardType: .phonePad, shouldHideText: false, textContentType: .telephoneNumber, useCustomDelegate: true)
    private let firstNumberDashLabel = MainParagraphLabel(text: "-")
    private let secondNumberTextField = TextField(placeHolderText: "", keyboardType: .phonePad, shouldHideText: false, textContentType: .telephoneNumber, useCustomDelegate: true)
    private let secondNumberDashLabel = MainParagraphLabel(text: "-")
    private let thirdNumberTextField = TextField(placeHolderText: "", keyboardType: .phonePad, shouldHideText: false, textContentType: .telephoneNumber, useCustomDelegate: true)
    
    private let nicknameLabel = MiddleTitleLabel(text: "닉네임을 입력해주세요.")
    private let nicknameTextField = TextField(placeHolderText: "6자 이내로 입력해주세요", keyboardType: .default, shouldHideText: false, textContentType: .nickname)
    private let nicknameTextFieldWithSubtitle: TextFieldWithSubtitle
    private let nicknameCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        button.setTitleColor(.white, for: .normal)
        button.configuration?.titlePadding = 0
        button.backgroundColor = .gray500
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let placeSelectLabel = MiddleTitleLabel(text: "동네를 입력해주세요.")
    private let selectPlaceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 15
        return button
    }()
    private let placeSelectButtonLabel = MainHighlightParagraphLabel(text: "동네 설정하기")
    private let placeSelectButtonArrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowRight
        return imageView
    }()
    
    private let nextButton = NextButton(text: "다음으로")
    
    override init(frame: CGRect) {
        nicknameTextFieldWithSubtitle = TextFieldWithSubtitle(textField: nicknameTextField)
        nicknameTextFieldWithSubtitle.setSubtitleText(textColor: .mainBlue, text: "공백 없이 한글/영문만 입력가능, 최대 6자", image: .warningIconMainBlue)
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setTextFieldDelegate()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubviews(nameLabel, nameTextField, genderLabel, maleButton, femaleButton, birthdayLabel, yearTextField, yearLabel, monthTextField, monthLabel, dayTextField, dayLabel, phoneNumberLabel, firstNumberTextField, firstNumberDashLabel, secondNumberTextField, secondNumberDashLabel, thirdNumberTextField, nicknameLabel, nicknameTextFieldWithSubtitle, placeSelectLabel, selectPlaceButton, nextButton)
        nicknameTextField.addSubview(nicknameCheckButton)
        selectPlaceButton.addSubviews(placeSelectButtonLabel ,placeSelectButtonArrowIcon)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(selectPlaceButton.snp.bottom).offset(144)
        }
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(24)
        }
        nameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.height.equalTo(46)
        }
        genderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(nameTextField.snp.bottom).offset(48)
        }
        femaleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(genderLabel.snp.bottom).offset(20)
            make.width.equalTo(38)
            make.height.equalTo(46)
        }
        maleButton.snp.makeConstraints { make in
            make.trailing.equalTo(femaleButton.snp.leading).offset(-12)
            make.top.equalTo(genderLabel.snp.bottom).offset(20)
            make.width.equalTo(38)
            make.height.equalTo(46)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(maleButton.snp.bottom).offset(48)
        }
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(70)
            make.height.equalTo(46)
        }
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(yearTextField.snp.trailing).offset(5)
        }
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(20)
            make.leading.equalTo(yearLabel.snp.trailing).offset(21)
            make.width.equalTo(70)
            make.height.equalTo(46)
        }
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(monthTextField.snp.trailing).offset(5)
        }
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(20)
            make.leading.equalTo(monthLabel.snp.trailing).offset(21)
            make.width.equalTo(70)
            make.height.equalTo(46)
        }
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.leading.equalTo(dayTextField.snp.trailing).offset(5)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
        firstNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(70)
            make.height.equalTo(46)
        }
        firstNumberDashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstNumberTextField.snp.centerY)
            make.leading.equalTo(firstNumberTextField.snp.trailing).offset(10)
        }
        secondNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.leading.equalTo(firstNumberDashLabel.snp.trailing).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(46)
        }
        secondNumberDashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(secondNumberTextField.snp.centerY)
            make.leading.equalTo(secondNumberTextField.snp.trailing).offset(10)
        }
        thirdNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.leading.equalTo(secondNumberDashLabel.snp.trailing).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(46)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdNumberTextField.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().offset(20)
        }
        nicknameTextFieldWithSubtitle.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        nicknameCheckButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField.snp.centerY)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(65)
            make.height.equalTo(33)
        }
        placeSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldWithSubtitle.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        selectPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(placeSelectLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
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
    }
    
    private func setButtonAction() {
        maleButton.setTitleColor(.white, for: .selected)
        maleButton.setTitleColor(.gray500, for: .normal)
        femaleButton.setTitleColor(.white, for: .selected)
        femaleButton.setTitleColor(.gray500, for: .normal)
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        nicknameCheckButton.addTarget(self, action: #selector(nicknameCheckButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        selectPlaceButton.addTarget(self, action: #selector(placeSelectButtonTapped), for: .touchUpInside)
    }
    
    private func setTextFieldDelegate() {
        nameTextField.delegate = self
        firstNumberTextField.delegate = self
        secondNumberTextField.delegate = self
        thirdNumberTextField.delegate = self
        yearTextField.delegate = self
        monthTextField.delegate = self
        dayTextField.delegate = self
        nicknameTextField.delegate = self
    }
    
    private func updateButtonState() {
        nextButton.setButtonState(isEnabled: !checkEmpty())
    }
    
    private func checkDetailState() -> Bool {
        if let name = nameTextField.text, !name.isEmpty {
            self.name = name
        }else {
            showErrorAlert(message: "정확한 이름을 입력해주세요")
            return false
        }
        if let year = Int(yearTextField.text ?? ""),
           year >= 1900, year <= 2100, // 연도 범위 검사
           let month = Int(monthTextField.text ?? ""),
           (1...12).contains(month),  // 월 범위 검사
           let day = Int(dayTextField.text ?? ""),
           (1...31).contains(day),    // 일 범위 검사
           isValidDate(year: year, month: month, day: day) { // 날짜 유효성 검사
            self.birthday = "\(year)\(String(format: "%02d", month))\(String(format: "%02d", day))"
        } else {
            showErrorAlert(message: "정확한 생년월일을 입력해주세요")
            return false
        }
        if let first = firstNumberTextField.text, (first.count == 3), let second = secondNumberTextField.text, (second.count >= 3), let third = thirdNumberTextField.text, (third.count >= 4) {
            self.number = first+second+third
        }else {
            showErrorAlert(message: "정확한 전화번호를 입력해주세요")
            return false
        }
        if let nickname = nicknameTextField.text, nickname == self.nickname {
            self.nickname = nickname
        }else {
            showErrorAlert(message: "닉네임 중복검사를 해주세요")
            return false
        }
        if let place = placeSelectButtonLabel.text, place != "동네 설정하기" {
            self.place = place
        }else {
            showErrorAlert(message: "동네 설정을 완료해주세요")
            return false
        }
        return true
    }
    
    private func checkEmpty() -> Bool {
        let textFields: [UITextField] = [
            nameTextField,
            yearTextField,
            monthTextField,
            dayTextField,
            firstNumberTextField,
            secondNumberTextField,
            thirdNumberTextField,
            nicknameTextField
        ]
        
        for textField in textFields {
            if let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true
            }
        }
        if didSetGender {
            return false
        }else {
            return true
        }
    }
    
    
    private func isValidDate(year: Int, month: Int, day: Int) -> Bool {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents) != nil
    }
    
    @objc private func maleButtonTapped() {
        didSetGender = true
        maleButton.isSelected = true
        femaleButton.isSelected = false
        maleButton.backgroundColor = maleButton.isSelected ? .mainBlue : .gray100
        femaleButton.backgroundColor = femaleButton.isSelected ? .mainBlue : .gray100
    }
    
    @objc private func femaleButtonTapped() {
        didSetGender = true
        femaleButton.isSelected = true
        maleButton.isSelected = false
        maleButton.backgroundColor = maleButton.isSelected ? .mainBlue : .gray100
        femaleButton.backgroundColor = femaleButton.isSelected ? .mainBlue : .gray100
    }
    
    @objc private func nicknameCheckButtonTapped() {
        delegate?.shouldCheckNickname(nicknameTextField)
    }
    
    @objc private func placeSelectButtonTapped() {
        delegate?.didTapPlaceSelectButton(self)
    }
    
    @objc private func nextButtonTapped() {
        guard checkDetailState() else { return }
        delegate?.didTapNextButton(self)
    }
    
    private func showErrorAlert(message: String) {
        if let vc = self.getViewController() {
            CustomAlertViewController.CustomAlertBuilder(viewController: vc)
                .setTitleState(.useTitleOnly)
                .setTitleText(message)
                .setButtonState(.singleButton)
                .setSingleButtonTitle("돌아가기")
                .showAlertView()
        }
    }
    
    func updateNicknameState(isVaild: Bool, nickname: String) {
        if isVaild {
            if let vc = self.getViewController() {
                CustomAlertViewController.CustomAlertBuilder(viewController: vc)
                    .setTitleState(.useTitleOnly)
                    .setTitleText("사용하실 수 있는 닉네임입니다")
                    .setButtonState(.doubleButton)
                    .setLeftButtonTitle("취소")
                    .setRightButtonTitle("사용하기")
                    .setRightButtonAction({
                        self.nickname = nickname
                        self.nicknameCheckButton.backgroundColor = .mainBlue
                        self.nicknameCheckButton.setTitle("사용가능", for: .normal)
                        self.nicknameCheckButton.setTitleColor(.white, for: .normal)
                    })
                    .showAlertView()
            }
        }else {
            showErrorAlert(message: "중복된 닉네임입니다.")
        }
    }
    
    func updatePlaceState(place: String, latitude: Double, longitude: Double) {
        self.place = place
        self.latitude = latitude
        self.longtitude = longitude
        placeSelectButtonLabel.text = place
    }
}

extension SignupDetailView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        let maxCharacters = switch textField {
        case self.nameTextField: 4
        case self.nicknameTextField: 6
        case self.yearTextField: 4
        case self.monthTextField: 2
        case self.dayTextField: 2
        case self.firstNumberTextField: 3
        case self.secondNumberTextField: 4
        case self.thirdNumberTextField: 4
        default: 0
        }
        
        if let currentText = textField.text {
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if updatedText.count <= maxCharacters {
                
                // 생년월일 입력 처리
                if textField == yearTextField {
                    if newLength == 4 {
                        DispatchQueue.main.async { self.monthTextField.becomeFirstResponder() }
                    }
                    return newLength <= 4
                } else if textField == monthTextField {
                    if newLength == 2 {
                        DispatchQueue.main.async { self.dayTextField.becomeFirstResponder() }
                    }
                    return newLength <= 2
                } else if textField == dayTextField {
                    if newLength == 2 {
                        DispatchQueue.main.async { self.firstNumberTextField.becomeFirstResponder() }
                    }
                    return newLength <= 2
                }
                
                // 전화번호 입력 처리
                else if textField == firstNumberTextField {
                    if newLength == 3 {
                        DispatchQueue.main.async { self.secondNumberTextField.becomeFirstResponder() }
                    }
                    return newLength <= 3
                } else if textField == secondNumberTextField {
                    if newLength == 4 {
                        DispatchQueue.main.async { self.thirdNumberTextField.becomeFirstResponder() }
                    }
                    return newLength <= 4
                } else if textField == thirdNumberTextField {
                    if newLength == 4 {
                        DispatchQueue.main.async { self.nicknameTextField.becomeFirstResponder() }
                    }
                }
                
                // 닉네임 입력 처리
                else if textField == nicknameTextField {
                    nicknameTextFieldWithSubtitle.setSubtitleText(textColor: .mainBlue, text: "공백 없이 한글/영문만 입력가능, 최대 6자", image: .warningIconMainBlue)
                    // 닉네임 내용 변경 시 중복 검사 상태 초기화
                    nicknameCheckButton.backgroundColor = .gray500
                    nicknameCheckButton.setTitle("중복확인", for: .normal)
                    nicknameCheckButton.setTitleColor(.white, for: .normal)
                    self.nickname = ""
                    
                    // 공백 제한
                    if string.contains(" ") {
                        return false
                    }
                    
                    // 한글/영문만 입력 가능
                    let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z]*$"
                    let regex = try? NSRegularExpression(pattern: pattern)
                    if let regex = regex {
                        let range = NSRange(location: 0, length: string.utf16.count)
                        if !regex.matches(in: string, options: [], range: range).isEmpty == false {
                            return false
                        }
                    }
                    return true
                }

            }else {
                if textField == nicknameTextField {
                    nicknameTextFieldWithSubtitle.setSubtitleText(textColor: .negative, text: "최대 6자로만 입력해주세요", image: .warningIconNegative)
                    nicknameTextFieldWithSubtitle.shakeSubtitleLabel()
                }
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
    }
    
}
