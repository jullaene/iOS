//
//  MatchingApplyPetExperienceView.swift
//  walkmong
//
//  Created by 황채웅 on 1/10/25.
//

import UIKit

protocol MatchingApplyPetExperienceViewDelegate: AnyObject {
    func didSelectExperience(_ experienceYn: String)
}

final class MatchingApplyPetExperienceView: UIView {
    
    private let titleLabel = MiddleTitleLabel(text: "반려견을 키운 경험이 있나요?")
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    private let tenYearsButton = UIButton.createStyledButton(type: .largeSelection, style: .light, title: "10년 이상")
    private let fiveYearsButton = UIButton.createStyledButton(type: .largeSelection, style: .light, title: "5년 이상")
    private let threeYearsOverButton = UIButton.createStyledButton(type: .largeSelection, style: .light, title: "3년 이상")
    private let threeYearsUnderButton = UIButton.createStyledButton(type: .largeSelection, style: .light, title: "3년 미만")
    private let zeroButton = UIButton.createStyledButton(type: .largeSelection, style: .light, title: "반려동물을 키운 경험이 없어요")
    private let nextButton = NextButton(text: "다음으로")
    
    weak var delegate: MatchingApplyPetExperienceViewDelegate?
    
    private var selectedButton: UIButton?

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
        addSubviews(titleLabel, stackView, nextButton)
        stackView.addArrangedSubview(tenYearsButton)
        stackView.addArrangedSubview(fiveYearsButton)
        stackView.addArrangedSubview(threeYearsOverButton)
        stackView.addArrangedSubview(threeYearsUnderButton)
        stackView.addArrangedSubview(zeroButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(278)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-37)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(58)
        }
    }
    
    private func setButtonAction() {
        tenYearsButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        fiveYearsButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        threeYearsOverButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        threeYearsUnderButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        zeroButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        nextButton.setButtonState(isEnabled: true)
        if selectedButton != sender {
            if let previousButton = selectedButton {
                previousButton.isSelected = false
                previousButton.backgroundColor = .gray100
                previousButton.setTitleColor(.gray500, for: .normal)
            }
            self.selectedButton = sender
            if let currentButton = self.selectedButton {
                currentButton.isSelected = true
                currentButton.backgroundColor = .mainBlue
                currentButton.setTitleColor(.gray100, for: .selected)
            }
        }
    }
    
    private func getExperienceYn() -> String {
        return selectedButton == zeroButton ? "N" : "Y"
    }
    
    @objc private func nextButtonTapped() {
        delegate?.didSelectExperience(getExperienceYn())
    }
}
