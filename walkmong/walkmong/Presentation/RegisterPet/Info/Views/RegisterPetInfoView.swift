//
//  RegisterPetInfoView.swift
//  walkmong
//
//  Created by 황채웅 on 1/14/25.
//

import UIKit
import PhotosUI

protocol RegisterPetInfoViewDelegate: AnyObject {
    func didTapNextButton(name: String, dogSize: String, profile: UIImage, gender: String, birthYear: String, breed: String, weight: String, neuteringYn: String, rabiesYn: String, adultYn: String)
}

final class RegisterPetInfoView: UIView {
    
    private var imageSelected: Bool = false
    private var configuration = PHPickerConfiguration()
    private var picker: PHPickerViewController?
    private var weight: String = ""
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private let titleLabel = MiddleTitleLabel(text: "반려견의 정보를 알려주세요.")
    
    private let profileImageView: UIButton = {
        let button = UIButton()
        button.setImage(.profileImageNil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 69
        return button
    }()
    
    private let profileImageIconButton: UIButton = {
        let button = UIButton()
        button.setImage(.profileImageIcon, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    private let nameLabel = SmallTitleLabel(text: "반려견의 이름은 무엇인가요?")
    private let genderLabel = SmallTitleLabel(text: "반려견의 성별은 무엇인가요?")
    private let breedLabel = SmallTitleLabel(text: "반려견의 견종은 무엇인가요?")
    private let birthYearLabel = SmallTitleLabel(text: "반려견이 태어난 연도는 언제인가요?")
    private let adultLabel = SmallTitleLabel(text: "현재 반려견이 성견인가요?")
    private let weightLabel = SmallTitleLabel(text: "반려견의 현재 몸무게가 어떻게 되나요?")
    private let sizeLabel = SmallTitleLabel(text: "반려견의 크기가 어떻게 되나요?")
    private let surgeryLabel = SmallTitleLabel(text: "중성화 여부를 알려주세요.")
    private let shotLabel = SmallTitleLabel(text: "광견병 예방 주사를 접종 완료했나요?")
    
    private let nameTextField = TextField(placeHolderText: "이름을 적어주세요", keyboardType: .default, shouldHideText: false, textContentType: .none, useCustomDelegate: true)
    private let breedTextField = TextField(placeHolderText: "예) 믹스, 말티즈 ...", keyboardType: .default, shouldHideText: false, textContentType: .none, useCustomDelegate: true)
    private let yearTextField = TextField(placeHolderText: "20xx", keyboardType: .numberPad, shouldHideText: false, textContentType: .none, useCustomDelegate: true)
    private let weightTextField = TextField(placeHolderText: "몸무게를 입력해주세요", keyboardType: .numberPad, shouldHideText: false, textContentType: .none, useCustomDelegate: true)
    
    private let maleButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "수컷")
    private let femaleButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "암컷")
    private let adultYesButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "예")
    private let adultNoButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "아니오")
    private let smallBreedButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "소형견")
    private let mediumBreedButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "중형견")
    private let bigBreedButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "대형견")
    private let surgeryNoButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "미완료")
    private let surgeryYesButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "완료")
    private let shotNoButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "미완료")
    private let shotYesButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "완료")
    
    private let subTitleLabel = SubtitleLabel()
    
    private let nextButton = NextButton(text: "다음으로")

    
    weak var delegate: RegisterPetInfoViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraints()
        setButtonAction()
        setDelegate()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        addSubviews(scrollView)
        scrollView.addSubviews(scrollContentView, nextButton)
        scrollContentView.addSubviews(titleLabel,profileImageView,profileImageIconButton,nameLabel,nameTextField,genderLabel,maleButton,femaleButton,breedLabel,breedTextField,birthYearLabel,yearTextField,adultLabel,adultNoButton,adultYesButton,weightLabel,weightTextField,sizeLabel,subTitleLabel,smallBreedButton,mediumBreedButton,bigBreedButton,surgeryLabel,surgeryNoButton,surgeryYesButton,shotLabel,shotYesButton,shotNoButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(shotYesButton.snp.bottom).offset(144)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
            make.width.height.equalTo(138)
        }
        profileImageIconButton.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.width.height.equalTo(35)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        femaleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(genderLabel.snp.bottom).offset(20)
        }
        maleButton.snp.makeConstraints { make in
            make.trailing.equalTo(femaleButton.snp.leading).offset(-12)
            make.top.equalTo(genderLabel.snp.bottom).offset(20)
        }
        breedLabel.snp.makeConstraints { make in
            make.top.equalTo(maleButton.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        breedTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.top.equalTo(breedLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        birthYearLabel.snp.makeConstraints { make in
            make.top.equalTo(breedTextField.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        yearTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.top.equalTo(birthYearLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        adultLabel.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        adultYesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(adultLabel.snp.bottom).offset(20)
        }
        adultNoButton.snp.makeConstraints { make in
            make.trailing.equalTo(femaleButton.snp.leading).offset(-12)
            make.top.equalTo(adultLabel.snp.bottom).offset(20)
        }
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(adultNoButton.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        weightTextField.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.top.equalTo(weightLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        bigBreedButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
        }
        mediumBreedButton.snp.makeConstraints { make in
            make.trailing.equalTo(bigBreedButton.snp.leading).offset(-12)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
        }
        smallBreedButton.snp.makeConstraints { make in
            make.trailing.equalTo(mediumBreedButton.snp.leading).offset(-12)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
        }
        surgeryLabel.snp.makeConstraints { make in
            make.top.equalTo(smallBreedButton.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        surgeryYesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(surgeryLabel.snp.bottom).offset(20)
        }
        surgeryNoButton.snp.makeConstraints { make in
            make.trailing.equalTo(surgeryYesButton.snp.leading).offset(-12)
            make.top.equalTo(surgeryLabel.snp.bottom).offset(20)
        }
        shotLabel.snp.makeConstraints { make in
            make.top.equalTo(surgeryNoButton.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        shotYesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(shotLabel.snp.bottom).offset(20)
        }
        shotNoButton.snp.makeConstraints { make in
            make.trailing.equalTo(shotYesButton.snp.leading).offset(-12)
            make.top.equalTo(shotLabel.snp.bottom).offset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(46)
        }
    }
    
    private func setButtonAction() {
        let allButtons = [maleButton, femaleButton, adultYesButton, adultNoButton, smallBreedButton, mediumBreedButton, bigBreedButton, surgeryYesButton, surgeryNoButton, shotNoButton, shotYesButton]
        allButtons.forEach { button in
            button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        }
        profileImageView.addTarget(self, action: #selector(setPHPicker), for: .touchUpInside)
        profileImageIconButton.addTarget(self, action: #selector(setPHPicker), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        switch sender {
        case maleButton:
            maleButton.isSelected = true
            femaleButton.isSelected = false
        case femaleButton:
            femaleButton.isSelected = true
            maleButton.isSelected = false
        case adultYesButton:
            adultYesButton.isSelected = true
            adultNoButton.isSelected = false
        case adultNoButton:
            adultYesButton.isSelected = false
            adultNoButton.isSelected = true
        case smallBreedButton:
            smallBreedButton.isSelected = true
            mediumBreedButton.isSelected = false
            bigBreedButton.isSelected = false
        case mediumBreedButton:
            smallBreedButton.isSelected = false
            mediumBreedButton.isSelected = true
            bigBreedButton.isSelected = false
        case bigBreedButton:
            smallBreedButton.isSelected = false
            mediumBreedButton.isSelected = false
            bigBreedButton.isSelected = true
        case surgeryYesButton:
            surgeryYesButton.isSelected = true
            surgeryNoButton.isSelected = false
        case surgeryNoButton:
            surgeryYesButton.isSelected = false
            surgeryNoButton.isSelected = true
        case shotYesButton:
            shotYesButton.isSelected = true
            shotNoButton.isSelected = false
        case shotNoButton:
            shotYesButton.isSelected = false
            shotNoButton.isSelected = true
        default: break
        }
        updateButtonColor()
        updateNextButtonState()
    }
    
    private func updateButtonColor() {
        let allButtons = [maleButton, femaleButton, adultYesButton, adultNoButton, smallBreedButton, mediumBreedButton, bigBreedButton, surgeryYesButton, surgeryNoButton, shotNoButton, shotYesButton]
        allButtons.forEach { button in
            button.backgroundColor = button.isSelected ? .mainBlue : .gray100
            button.setTitleColor(.white, for: .selected)
            button.setTitleColor(.gray500, for: .normal)
        }
    }

    private func setUI() {
        subTitleLabel.setContent("현재 KG에 따라 입력해주세요.\n소형견 ~10kg  중형견 10kg~ 25kg  대형견 25kg~ ", textColor: .mainBlue, image: .warningIconMainBlue)
    }
    
    private func setDelegate() {
        [nameTextField, breedTextField, yearTextField, weightTextField].forEach { $0.delegate = self }
    }
    
    private func updateNextButtonState() {
        let isTextFieldValid = !nameTextField.text!.isEmpty &&
                               !breedTextField.text!.isEmpty &&
                               !yearTextField.text!.isEmpty &&
                               !weightTextField.text!.isEmpty
        
        let isGenderSelected = maleButton.isSelected || femaleButton.isSelected
        let isAdultSelected = adultYesButton.isSelected || adultNoButton.isSelected
        let isBreedSizeSelected = smallBreedButton.isSelected || mediumBreedButton.isSelected || bigBreedButton.isSelected
        let isSurgerySelected = surgeryYesButton.isSelected || surgeryNoButton.isSelected
        let isShotSelected = shotYesButton.isSelected || shotNoButton.isSelected
        
        let isAllValid = isTextFieldValid && isGenderSelected && isAdultSelected && isBreedSizeSelected && isSurgerySelected && isShotSelected && imageSelected
        
        nextButton.setButtonState(isEnabled: isAllValid)
    }
    
    @objc private func nextButtonTapped() {
        let name = nameTextField.text!
        let gender = maleButton.isSelected ? "MALE" : "FEMALE"
        let breed = breedTextField.text!
        let year = yearTextField.text!
        let adult = adultYesButton.isSelected ? "Y" : "N"
        let dogSize = smallBreedButton.isSelected ? "SMALL" : mediumBreedButton.isSelected ? "MEDIUM" : bigBreedButton.isSelected ? "BIG" : ""
        let neuteringYn = surgeryYesButton.isSelected ? "Y" : "N"
        let rabiesYn = shotYesButton.isSelected ? "Y" : "N"
        if let profile = profileImageView.imageView?.image {
            delegate?.didTapNextButton(name: name, dogSize: dogSize, profile: profile, gender: gender, birthYear: year, breed: breed, weight: weight, neuteringYn: neuteringYn, rabiesYn: rabiesYn, adultYn: adult)
        }
    }
    
}

extension RegisterPetInfoView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 입력 텍스트 전체 만들기
        guard let currentText = textField.text as NSString? else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        // yearTextField: 4자리 숫자만 허용
        if textField == yearTextField {
            if updatedText.count > 4 {
                return false // 4자리를 초과하면 입력 차단
            }
        }
        
        if textField != breedTextField {
            // 공백 입력 차단
            if string.contains(" ") {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // weightTextField에 "kg" 추가
        if textField == weightTextField {
            guard let text = textField.text, !text.isEmpty else { return }
            
            // 숫자만 있는지 확인
            if text.isNumber {
                weight = textField.text ?? "0"
                textField.text = "\(text) kg"
            } else if text.hasSuffix(" kg") {
                // 이미 "kg"가 있다면 그대로 둠
                return
            } else {
                // 잘못된 형식일 경우 초기화
                textField.text = ""
            }
        }
        
        // 버튼 상태 업데이트
        updateNextButtonState()
    }
    
    @objc private func setPHPicker() {
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 1
        picker = PHPickerViewController(configuration: configuration)
        picker?.delegate = self
        if let vc = self.getViewController() {
            vc.present(picker!, animated: true)
        }
    }

}

extension String {
    var isNumber: Bool {
        return !isEmpty && range(of: "^[0-9]+$", options: .regularExpression) != nil
    }
}

extension RegisterPetInfoView: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.profileImageView.setImage(image as? UIImage, for: .normal)
                    self.imageSelected = true
                    self.updateNextButtonState()
                    return
                }
            }
        } else {
            if let vc = self.getViewController() {
                CustomAlertViewController
                    .CustomAlertBuilder(viewController: vc)
                    .setTitleState(.useTitleOnly)
                    .setTitleText("이미지 불러오기 실패")
                    .setButtonState(.singleButton)
                    .setSingleButtonTitle("돌아가기")
                    .showAlertView()
            }
        }
        self.imageSelected = false
        self.profileImageView.setImage(.profileImageNil, for: .normal)
        self.nextButton.setButtonState(isEnabled: false)
    }
    
}
