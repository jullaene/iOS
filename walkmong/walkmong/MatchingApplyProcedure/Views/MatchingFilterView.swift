//
//  MatchingFilterView.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

protocol MatchingFilterViewDelegate: AnyObject {
    func didApplyFilter(selectedBreeds: [String], matchingStatus: [String])
}

class MatchingFilterView: UIView {
    
    // MARK: - Properties
    private let distanceFrame = UIView()
    private let breedFrame = UIView()
    private let matchingStatusFrame = UIView()
    private let buttonFrame = UIView()
    
    private var matchingButtons: [UIButton] = []
    private var breedButtons: [UIButton] = []
    private var distanceDots: [UIView] = []
    private var distanceLabels: [UILabel] = []
    
    private var resetButton = UIButton()
    private var applyButton = UIButton()
    
    weak var delegate: MatchingFilterViewDelegate?
    
    private let userDefaults = UserDefaults.standard
    private let matchingFilterKey = "MatchingFilter"
    private let breedFilterKey = "BreedFilter"
    private let distanceFilterKey = "DistanceFilter"
    
    private var selectedDistanceIndex: Int = 0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupLayout()
        loadFilterSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [distanceFrame, breedFrame, matchingStatusFrame, buttonFrame].forEach {
            $0.backgroundColor = .clear
            addSubview($0)
        }
        
        setupDistanceFrame()
        setupMatchingStatusFrame()
        setupBreedFrame()
        setupButtonFrame()
    }
    
    private func setupLayout() {
        distanceFrame.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        breedFrame.snp.makeConstraints { make in
            make.top.equalTo(distanceFrame.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(156)
        }
        
        matchingStatusFrame.snp.makeConstraints { make in
            make.top.equalTo(breedFrame.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(114)
        }
        
        buttonFrame.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview().inset(42)
            make.width.equalTo(356)
            make.height.equalTo(54)
        }
    }
    
    // MARK: - Frame Setups
    private func setupDistanceFrame() {
        let distanceLabel = createLabel(text: "거리", fontSize: 20, color: .mainBlack)
        let distanceSliderFrame = UIView()
        let sliderLine = createLineView(color: .gray300, height: 3)
        
        distanceFrame.addSubview(distanceLabel)
        distanceFrame.addSubview(distanceSliderFrame)
        distanceSliderFrame.addSubview(sliderLine)
        
        distanceLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        
        sliderLine.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(3)
        }
        
        distanceSliderFrame.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        setupDistanceSelection(sliderLine: sliderLine, container: distanceSliderFrame)
    }
    
    private func setupDistanceSelection(sliderLine: UIView, container: UIView) {
        let selectionData: [(text: String, positionMultiplier: CGFloat)] = [
            ("우리 동네\n(500m 이내)", 0),
            ("가까운동네\n(1km)", 0.5),
            ("먼동네\n(1.5km)", 1)
        ]
        
        DispatchQueue.main.async {
            sliderLine.layoutIfNeeded()
            let sliderWidth = sliderLine.frame.width
            
            for (index, data) in selectionData.enumerated() {
                let isSelected = index == self.selectedDistanceIndex
                
                let touchArea = UIView()
                touchArea.tag = index
                touchArea.isUserInteractionEnabled = true
                container.addSubview(touchArea)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDistanceTap(_:)))
                touchArea.addGestureRecognizer(tapGesture)
                
                let selectionDot = UIView()
                selectionDot.backgroundColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                selectionDot.layer.cornerRadius = isSelected ? 12 : 6
                touchArea.addSubview(selectionDot)
                self.distanceDots.append(selectionDot)
                
                let label = UILabel()
                label.textColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
                label.textAlignment = .center
                label.numberOfLines = 0
                label.text = data.text
                touchArea.addSubview(label)
                self.distanceLabels.append(label)
                
                touchArea.snp.makeConstraints { make in
                    make.centerX.equalTo(sliderLine.snp.leading).offset(data.positionMultiplier * sliderWidth)
                    make.centerY.equalTo(sliderLine)
                    make.width.equalTo(80)
                    make.height.equalTo(80)
                }
                
                selectionDot.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalTo(sliderLine)
                    make.size.equalTo(isSelected ? CGSize(width: 24, height: 24) : CGSize(width: 12, height: 12))
                }
                
                label.snp.makeConstraints { make in
                    make.top.equalTo(sliderLine.snp.bottom).offset(14)
                    make.centerX.equalTo(selectionDot)
                }
            }
        }
    }
    
    @objc private func handleDistanceTap(_ sender: UITapGestureRecognizer) {
        guard let tappedDot = sender.view else { return }
        let newIndex = tappedDot.tag
        updateDistanceSelection(selectedIndex: newIndex)
    }
    
    private func updateDistanceSelection(selectedIndex: Int) {
        selectedDistanceIndex = selectedIndex
        for (index, dot) in distanceDots.enumerated() {
            let isSelected = index == selectedDistanceIndex
            let newSize: CGFloat = isSelected ? 24 : 12

            UIView.animate(withDuration: 0.2, animations: {
                dot.backgroundColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                dot.snp.updateConstraints { make in
                    make.size.equalTo(CGSize(width: newSize, height: newSize))
                }
                dot.layer.cornerRadius = newSize / 2
                self.distanceLabels[index].textColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                dot.superview?.layoutIfNeeded()
            })
        }
        saveDistanceSelection()
    }
    
    private func saveDistanceSelection() {
        userDefaults.set(selectedDistanceIndex, forKey: distanceFilterKey)
    }
    
    private func loadDistanceSelection() {
        selectedDistanceIndex = userDefaults.integer(forKey: distanceFilterKey)
        updateDistanceSelection(selectedIndex: selectedDistanceIndex)
    }
    
    private func setupMatchingStatusFrame() {
        let label = createLabel(text: "매칭여부", fontSize: 20, color: .mainBlack)
        matchingStatusFrame.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }

        let buttonContainer = UIView()
        matchingStatusFrame.addSubview(buttonContainer)

        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }

        let buttonTitles = ["매칭중", "매칭확정"]
        for title in buttonTitles {
            let button = UIButton.createStyledButton(style: .light, size: .small2, title: title)
            button.addTarget(self, action: #selector(matchingButtonTapped(_:)), for: .touchUpInside)
            buttonContainer.addSubview(button)
            matchingButtons.append(button)
        }

        for (index, button) in matchingButtons.enumerated() {
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(matchingButtons[index - 1].snp.trailing).offset(12)
                }
                make.top.bottom.equalToSuperview()
            }
        }
    }
    private func setupBreedFrame() {
        let breedLabel = createLabel(text: "견종", fontSize: 20, color: .mainBlack)
        let instructionLabel = UILabel()
        instructionLabel.frame = CGRect(x: 0, y: 0, width: 353, height: 22)
        instructionLabel.textColor = UIColor.mainBlack
        instructionLabel.font = UIFont(name: "Pretendard-Medium", size: 16)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        instructionLabel.attributedText = NSMutableAttributedString(
            string: "산책이 가능한 견종을 모두 선택해주세요.",
            attributes: [
                NSAttributedString.Key.kern: -0.32,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )

        breedFrame.addSubview(breedLabel)
        breedFrame.addSubview(instructionLabel)

        breedLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }

        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(breedLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }

        let buttonContainer = UIView()
        breedFrame.addSubview(buttonContainer)

        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }

        let buttonTitles = ["소형견", "중형견", "대형견"]
        for title in buttonTitles {
            let button = UIButton.createStyledButton(style: .light, size: .small2, title: title)
            button.addTarget(self, action: #selector(breedButtonTapped(_:)), for: .touchUpInside)
            buttonContainer.addSubview(button)
            breedButtons.append(button)
        }

        for (index, button) in breedButtons.enumerated() {
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(breedButtons[index - 1].snp.trailing).offset(12)
                }
                make.top.bottom.equalToSuperview()
            }
        }
    }
    
    private func setupButtonFrame() {
        resetButton = UIButton.createStyledButton(style: .light, size: .medium, title: "초기화")
        applyButton = UIButton.createStyledButton(style: .dark, size: .medium, title: "적용하기")

        buttonFrame.addSubview(resetButton)
        buttonFrame.addSubview(applyButton)

        resetButton.addTarget(self, action: #selector(resetFilter), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)

        // 초기화 버튼 오토레이아웃
        resetButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(93)
            make.height.equalTo(54)
        }

        // 적용하기 버튼 오토레이아웃
        applyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(resetButton.snp.trailing).offset(12)
        }
    }
    
    // MARK: - Utility Methods
    private func createLabel(text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Pretendard-Bold", size: fontSize)
        label.textColor = color
        return label
    }
    
    private func createLineView(color: UIColor, height: CGFloat) -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = color
        return lineView
    }
    
    private func configureButton(_ button: UIButton, title: String, backgroundColor: UIColor, textColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 15
    }
    
    private func setupFilterFrame(label: UILabel, container: UIView, buttonTitles: [String], buttons: inout [UIButton], action: Selector) {
        let buttonContainer = UIView()
        container.addSubview(label)
        container.addSubview(buttonContainer)
        
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }
        
        for title in buttonTitles {
            let button = createToggleButton(title: title)
            button.addTarget(self, action: action, for: .touchUpInside)
            buttonContainer.addSubview(button)
            buttons.append(button)
        }
        
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(buttons[index - 1].snp.trailing).offset(12)
                }
                make.top.bottom.equalToSuperview()
                make.height.equalTo(38)
            }
            
            // 동적 크기 조정: 텍스트에 따라 너비 설정
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                config.baseBackgroundColor = .gray100
                config.baseForegroundColor = .gray500
                button.configuration = config
            } else {
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                button.backgroundColor = .gray100
                button.setTitleColor(.gray500, for: .normal)
            }
        }
    }
    
    private func createToggleButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.backgroundColor = .gray100
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.layer.cornerRadius = 19
        button.tag = 0
        return button
    }
    
    @objc private func matchingButtonTapped(_ sender: UIButton) {
        toggleMultipleSelection(sender, buttons: matchingButtons)
    }

    @objc private func breedButtonTapped(_ sender: UIButton) {
        toggleMultipleSelection(sender, buttons: breedButtons)
    }
    
    private func toggleMultipleSelection(_ button: UIButton, buttons: [UIButton]) {
        let isSelected = button.tag == 1
        updateButtonState(button, isSelected: !isSelected)
    }

    private func updateButtonState(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .gray600 : .gray100
        button.setTitleColor(isSelected ? .white : .gray500, for: .normal)
        button.tag = isSelected ? 1 : 0
    }
    
    @objc private func resetFilter() {
        for button in matchingButtons + breedButtons {
            updateButtonState(button, isSelected: false)
        }
        selectedDistanceIndex = 0
        updateDistanceSelection(selectedIndex: selectedDistanceIndex)
        userDefaults.removeObject(forKey: matchingFilterKey)
        userDefaults.removeObject(forKey: breedFilterKey)
        userDefaults.removeObject(forKey: distanceFilterKey)
    }
    
    @objc private func applyFilter() {
        saveFilterSettings()
        let selectedBreeds = breedButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        let selectedMatchingStatus = matchingButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        delegate?.didApplyFilter(selectedBreeds: selectedBreeds, matchingStatus: selectedMatchingStatus)
    }
    
    private func toggleButton(_ button: UIButton, buttons: [UIButton]) {
        let isSelected = button.tag == 1
        buttons.forEach { updateButtonState($0, isSelected: $0 == button && !isSelected) }
    }
    
    private func saveFilterSettings() {
        let selectedMatchingStatus = matchingButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        let selectedBreeds = breedButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        userDefaults.set(selectedMatchingStatus, forKey: matchingFilterKey)
        userDefaults.set(selectedBreeds, forKey: breedFilterKey)
        saveDistanceSelection()
    }
    
    private func loadFilterSettings() {
        loadDistanceSelection()
        let savedMatchingStatus = userDefaults.array(forKey: matchingFilterKey) as? [String] ?? []
        let savedBreeds = userDefaults.array(forKey: breedFilterKey) as? [String] ?? []
        matchingButtons.forEach { updateButtonState($0, isSelected: savedMatchingStatus.contains($0.title(for: .normal) ?? "")) }
        breedButtons.forEach { updateButtonState($0, isSelected: savedBreeds.contains($0.title(for: .normal) ?? "")) }
    }
}
