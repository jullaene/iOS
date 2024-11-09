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
    
    private let distanceFrame = UIView()
    private let breedFrame = UIView()
    private let matchingStatusFrame = UIView()
    private let buttonFrame = UIView()
    
    private var matchingButtons: [UIButton] = [] // 매칭 여부 버튼 배열
    private var breedButtons: [UIButton] = [] // 견종 버튼 배열
    
    private let resetButton = UIButton() // 초기화 버튼
    private let applyButton = UIButton() // 적용 버튼
    
    weak var delegate: MatchingFilterViewDelegate?
    
    private let userDefaults = UserDefaults.standard
    private let matchingFilterKey = "MatchingFilter"
    private let breedFilterKey = "BreedFilter"
   
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // 뷰 구성
        setupLayout() // 레이아웃 구성
        loadFilterSettings() // 저장된 필터 설정 불러오기
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 구성
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        distanceFrame.backgroundColor = .clear
        breedFrame.backgroundColor = .clear
        matchingStatusFrame.backgroundColor = .clear
        
        self.addSubview(distanceFrame)
        self.addSubview(breedFrame)
        self.addSubview(matchingStatusFrame)
        self.addSubview(buttonFrame)
        
        setupDistanceFrame()
        setupMatchingStatus()
        setupBreedFrame()
        setupButtons()
    }
    
    // MARK: - 레이아웃 구성
    private func setupLayout() {
        distanceFrame.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(145)
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
    
    // MARK: - 거리 프레임
    private func setupDistanceFrame() {
        let distanceLabel = UILabel()
        distanceLabel.text = "거리"
        distanceLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        distanceLabel.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        distanceFrame.addSubview(distanceLabel)
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    // MARK: - 매칭 여부 프레임
    private func setupMatchingStatus() {
        let statusLabel = UILabel()
        statusLabel.text = "매칭여부"
        statusLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        statusLabel.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        matchingStatusFrame.addSubview(statusLabel)
        
        let buttonContainer = UIView()
        matchingStatusFrame.addSubview(buttonContainer)
        
        let buttonTitles = ["매칭중", "매칭확정"]
        for title in buttonTitles {
            let button = createToggleButton(title: title)
            button.addTarget(self, action: #selector(matchingButtonTapped(_:)), for: .touchUpInside)
            buttonContainer.addSubview(button)
            matchingButtons.append(button)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }
        
        for (index, button) in matchingButtons.enumerated() {
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(matchingButtons[index - 1].snp.trailing).offset(12)
                }
                make.width.equalTo(73)
                make.height.equalTo(38)
            }
        }
    }
    
    // MARK: - 견종 프레임
    private func setupBreedFrame() {
        let breedLabel = UILabel()
        breedLabel.text = "견종"
        breedLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        breedLabel.textColor = UIColor(red: 0.081, green: 0.081, blue: 0.076, alpha: 1)
        breedFrame.addSubview(breedLabel)
        
        let buttonContainer = UIView()
        breedFrame.addSubview(buttonContainer)
        
        let buttonTitles = ["소형견", "중형견", "대형견"]
        for title in buttonTitles {
            let button = createToggleButton(title: title)
            button.addTarget(self, action: #selector(breedButtonTapped(_:)), for: .touchUpInside)
            buttonContainer.addSubview(button)
            breedButtons.append(button)
        }
        
        breedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(breedLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }
        
        for (index, button) in breedButtons.enumerated() {
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(breedButtons[index - 1].snp.trailing).offset(12)
                }
                make.width.equalTo(73)
                make.height.equalTo(38)
            }
        }
    }
    
    // MARK: - 버튼 프레임
    private func setupButtons() {
        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        resetButton.layer.cornerRadius = 15
        buttonFrame.addSubview(resetButton)
        
        applyButton.setTitle("적용하기", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = UIColor(red: 0.198, green: 0.203, blue: 0.222, alpha: 1)
        applyButton.layer.cornerRadius = 15
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
    
    // MARK: - 공통 버튼 생성 메서드
    private func createToggleButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clear.cgColor
        button.clipsToBounds = true
        button.tag = 0
        return button
    }
    
    // MARK: - 버튼 클릭 이벤트
    @objc private func matchingButtonTapped(_ sender: UIButton) {
        toggleButton(sender)
    }
    
    @objc private func breedButtonTapped(_ sender: UIButton) {
        toggleButton(sender)
    }
    
    private func toggleButton(_ button: UIButton) {
        let isSelected = button.tag == 1
        
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = .identity
            })
        })
        
        if isSelected {
            updateButtonState(button, isSelected: false)
        } else {
            updateButtonState(button, isSelected: true)
        }
    }
    
    // MARK: - 필터 설정 저장
    private func saveFilterSettings() {
        let selectedMatchingStatus = matchingButtons
            .filter { $0.tag == 1 }
            .compactMap { $0.title(for: .normal) }
        let selectedBreeds = breedButtons
            .filter { $0.tag == 1 }
            .compactMap { $0.title(for: .normal) }
        
        userDefaults.set(selectedMatchingStatus, forKey: matchingFilterKey)
        userDefaults.set(selectedBreeds, forKey: breedFilterKey)
    }
    
    // MARK: - 필터 설정 불러오기
    private func loadFilterSettings() {
        let savedMatchingStatus = userDefaults.array(forKey: matchingFilterKey) as? [String] ?? []
        let savedBreeds = userDefaults.array(forKey: breedFilterKey) as? [String] ?? []
        
        for button in matchingButtons {
            let isSelected = savedMatchingStatus.contains(button.title(for: .normal) ?? "")
            updateButtonState(button, isSelected: isSelected)
        }
        
        for button in breedButtons {
            let isSelected = savedBreeds.contains(button.title(for: .normal) ?? "")
            updateButtonState(button, isSelected: isSelected)
        }
    }
    
    // MARK: - 버튼 상태 업데이트
    private func updateButtonState(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1).cgColor
            button.tag = 1
        } else {
            button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
            button.setTitleColor(UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1), for: .normal)
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
            button.tag = 0
        }
    }
    
    // MARK: - 적용 버튼 이벤트
    @objc private func applyFilter() {
        saveFilterSettings()
        
        let selectedBreeds = breedButtons
            .filter { $0.tag == 1 }
            .compactMap { $0.title(for: .normal) }
        
        let selectedMatchingStatus = matchingButtons
            .filter { $0.tag == 1 }
            .compactMap { $0.title(for: .normal) }
        
        delegate?.didApplyFilter(selectedBreeds: selectedBreeds, matchingStatus: selectedMatchingStatus)
    }
    
    // MARK: - 초기화 버튼 이벤트
    @objc private func resetFilter() {
        for button in matchingButtons {
            updateButtonState(button, isSelected: false)
        }

        for button in breedButtons {
            updateButtonState(button, isSelected: false)
        }
        
        userDefaults.removeObject(forKey: matchingFilterKey)
        userDefaults.removeObject(forKey: breedFilterKey)
    }
}
