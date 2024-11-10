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
    
    private let resetButton = UIButton()
    private let applyButton = UIButton()
    
    weak var delegate: MatchingFilterViewDelegate?
    
    private let userDefaults = UserDefaults.standard
    private let matchingFilterKey = "MatchingFilter"
    private let breedFilterKey = "BreedFilter"
    
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
            make.top.equalToSuperview().offset(25)
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
            make.centerX.bottom.equalToSuperview().inset(38)
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
    
    private func setupMatchingStatusFrame() {
        setupFilterFrame(
            label: createLabel(text: "매칭여부", fontSize: 20, color: .mainBlack),
            container: matchingStatusFrame,
            buttonTitles: ["매칭중", "매칭확정"],
            buttons: &matchingButtons,
            action: #selector(matchingButtonTapped(_:))
        )
    }
    
    private func setupBreedFrame() {
        setupFilterFrame(
            label: createLabel(text: "견종", fontSize: 20, color: .mainBlack),
            container: breedFrame,
            buttonTitles: ["소형견", "중형견", "대형견"],
            buttons: &breedButtons,
            action: #selector(breedButtonTapped(_:))
        )
    }
    
    private func setupButtonFrame() {
        configureButton(resetButton, title: "초기화", backgroundColor: .gray100, textColor: .black)
        configureButton(applyButton, title: "적용하기", backgroundColor: .gray600, textColor: .white)
        
        buttonFrame.addSubview(resetButton)
        buttonFrame.addSubview(applyButton)
        
        resetButton.addTarget(self, action: #selector(resetFilter), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        
        resetButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(93)
            make.height.equalTo(54)
        }
        
        applyButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(251)
            make.height.equalTo(54)
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
                make.width.equalTo(73)
                make.height.equalTo(38)
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
                let isSelected = index == 0
                let selectionDot = UIView()
                selectionDot.backgroundColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                selectionDot.layer.cornerRadius = isSelected ? 12 : 6
                container.addSubview(selectionDot)
                
                let label = UILabel()
                label.textColor = isSelected ? UIColor.mainBlue : UIColor.gray300
                label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
                label.textAlignment = .center
                label.numberOfLines = 0
                label.text = data.text
                container.addSubview(label)
                
                selectionDot.snp.makeConstraints { make in
                    make.centerY.equalTo(sliderLine)
                    make.centerX.equalTo(sliderLine.snp.leading).offset(data.positionMultiplier * sliderWidth)
                    make.size.equalTo(isSelected ? CGSize(width: 24, height: 24) : CGSize(width: 12, height: 12))
                }
                
                label.snp.makeConstraints { make in
                    make.top.equalTo(selectionDot.snp.bottom).offset(4)
                    make.centerX.equalTo(selectionDot)
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func matchingButtonTapped(_ sender: UIButton) {
        toggleButton(sender)
    }
    
    @objc private func breedButtonTapped(_ sender: UIButton) {
        toggleButton(sender)
    }
    
    @objc private func resetFilter() {
        for button in matchingButtons + breedButtons {
            updateButtonState(button, isSelected: false)
        }
        userDefaults.removeObject(forKey: matchingFilterKey)
        userDefaults.removeObject(forKey: breedFilterKey)
    }
    
    @objc private func applyFilter() {
        saveFilterSettings()
        let selectedBreeds = breedButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        let selectedMatchingStatus = matchingButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        delegate?.didApplyFilter(selectedBreeds: selectedBreeds, matchingStatus: selectedMatchingStatus)
    }
    
    private func toggleButton(_ button: UIButton) {
        let isSelected = button.tag == 1
        UIView.animate(withDuration: 0.2) {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }
        }
        updateButtonState(button, isSelected: !isSelected)
    }
    
    private func updateButtonState(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .mainBlue : .gray100
        button.setTitleColor(isSelected ? .white : .gray500, for: .normal)
        button.layer.borderWidth = isSelected ? 2 : 0
        button.layer.borderColor = isSelected ? UIColor.mainBlue.cgColor : UIColor.clear.cgColor
        button.tag = isSelected ? 1 : 0
    }
    
    // MARK: - UserDefaults
    private func saveFilterSettings() {
        let selectedMatchingStatus = matchingButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        let selectedBreeds = breedButtons.filter { $0.tag == 1 }.compactMap { $0.title(for: .normal) }
        userDefaults.set(selectedMatchingStatus, forKey: matchingFilterKey)
        userDefaults.set(selectedBreeds, forKey: breedFilterKey)
    }
    
    private func loadFilterSettings() {
        let savedMatchingStatus = userDefaults.array(forKey: matchingFilterKey) as? [String] ?? []
        let savedBreeds = userDefaults.array(forKey: breedFilterKey) as? [String] ?? []
        matchingButtons.forEach { updateButtonState($0, isSelected: savedMatchingStatus.contains($0.title(for: .normal) ?? "")) }
        breedButtons.forEach { updateButtonState($0, isSelected: savedBreeds.contains($0.title(for: .normal) ?? "")) }
    }
}
