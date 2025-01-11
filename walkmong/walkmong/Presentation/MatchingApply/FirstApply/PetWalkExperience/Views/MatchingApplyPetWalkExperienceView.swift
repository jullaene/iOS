//
//  MatchingApplyPetWalkExperienceView.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

protocol MatchingApplyPetWalkExperienceViewDelegate: AnyObject {
    func didTapNextButton(_ experience: Bool, _ breed: String)
}

final class MatchingApplyPetWalkExperienceView: UIView {
    
    private let titleLabel = MiddleTitleLabel(text: "반려견 산책과 관련된 질문입니다.")
    
    private let experienceLabel = SmallTitleLabel(text: "반려견을 산책시킨 경험이 있나요?")
    private let experienceMainLabel = MainParagraphLabel(text: "반려견을 산책시킨 경험이")
    private let experienceNoButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "없어요")
    private let experienceYesButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "있어요")
    
    private let breedLabel = SmallTitleLabel(text: "반려견을 산책시킨 경험이 있나요?")
    private let breedMainLabel = MainParagraphLabel(text: "산책이 가능한 견종을 모두 선택해주세요")
    private let smallBreedButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "소형견")
    private let mediumBreedButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "중형견")
    private let bigBreedButton = UIButton.createStyledButton(type: .smallSelection, style: .light, title: "대형견")
    
    private let nextButton = NextButton(text: "다음으로")
    
    private var selectedExperienceButton: UIButton?
    private var selectedBreedButton: UIButton?
    
    weak var delegate: MatchingApplyPetWalkExperienceViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setConstraints()
        setButtonAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubviews(titleLabel, experienceLabel, experienceMainLabel, experienceNoButton, experienceYesButton, breedLabel, breedMainLabel, smallBreedButton, mediumBreedButton, bigBreedButton, nextButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        experienceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
        }
        experienceMainLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(experienceLabel.snp.bottom).offset(24)
        }
        experienceYesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(experienceMainLabel)
        }
        experienceNoButton.snp.makeConstraints { make in
            make.trailing.equalTo(experienceYesButton.snp.leading).offset(-12)
            make.centerY.equalTo(experienceMainLabel)
        }
        breedLabel.snp.makeConstraints { make in
            make.top.equalTo(experienceMainLabel.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        breedMainLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(breedLabel.snp.bottom).offset(20)
        }
        smallBreedButton.snp.makeConstraints { make in
            make.top.equalTo(breedMainLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        mediumBreedButton.snp.makeConstraints { make in
            make.centerY.equalTo(smallBreedButton.snp.centerY)
            make.leading.equalTo(smallBreedButton.snp.trailing).offset(12)
        }
        bigBreedButton.snp.makeConstraints { make in
            make.centerY.equalTo(smallBreedButton.snp.centerY)
            make.leading.equalTo(mediumBreedButton.snp.trailing).offset(12)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    private func setButtonAction() {
        experienceNoButton.addTarget(self, action: #selector(experienceButtonTapped), for: .touchUpInside)
        experienceYesButton.addTarget(self, action: #selector(experienceButtonTapped), for: .touchUpInside)
        smallBreedButton.addTarget(self, action: #selector(breedButtonTapped), for: .touchUpInside)
        mediumBreedButton.addTarget(self, action: #selector(breedButtonTapped), for: .touchUpInside)
        bigBreedButton.addTarget(self, action: #selector(breedButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func breedButtonTapped(_ sender: UIButton) {
        if selectedBreedButton != sender {
            if let previousButton = selectedBreedButton {
                previousButton.isSelected = false
                previousButton.backgroundColor = .gray100
                previousButton.setTitleColor(.gray500, for: .normal)
            }
            self.selectedBreedButton = sender
            if let currentButton = self.selectedBreedButton {
                currentButton.isSelected = true
                currentButton.backgroundColor = .mainBlue
                currentButton.setTitleColor(.gray100, for: .selected)
            }
        }
        if let _ = selectedBreedButton, let _ = selectedExperienceButton {
            nextButton.setButtonState(isEnabled: true)
        }
    }
    
    @objc private func experienceButtonTapped(_ sender: UIButton) {
        if selectedExperienceButton != sender {
            if let previousButton = selectedExperienceButton {
                previousButton.isSelected = false
                previousButton.backgroundColor = .gray100
                previousButton.setTitleColor(.gray500, for: .normal)
            }
            self.selectedExperienceButton = sender
            if let currentButton = self.selectedExperienceButton {
                currentButton.isSelected = true
                currentButton.backgroundColor = .mainBlue
                currentButton.setTitleColor(.gray100, for: .selected)
            }
        }
        if let _ = selectedBreedButton, let _ = selectedExperienceButton {
            nextButton.setButtonState(isEnabled: true)
        }
    }
    
    @objc private func nextButtonTapped() {
        let selectedBreed = switch selectedBreedButton {
        case smallBreedButton:
            "SMALL"
        case mediumBreedButton:
            "MEDIUM"
        default:
            "BIG"
        }
        delegate?.didTapNextButton(selectedExperienceButton == experienceYesButton, selectedBreed)
    }
}
