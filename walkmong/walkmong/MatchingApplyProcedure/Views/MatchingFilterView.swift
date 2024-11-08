//
//  MatchingFilterView.swift
//  walkmong
//
//  Created by 황채웅 on 11/3/24.
//

import UIKit
import SnapKit

class MatchingFilterView: UIView {
    
    private let distanceFrame = UIView()
    private let breedFrame = UIView()
    private let matchingStatusFrame = UIView()
    private let buttonFrame = UIView()
    
    private var matchingButtons: [UIButton] = [] // 매칭 여부 버튼 배열
    private var breedButtons: [UIButton] = [] // 견종 버튼 배열
    
    private let resetButton = UIButton() // 초기화 버튼
    private let applyButton = UIButton() // 적용 버튼
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // 뷰 구성
        setupLayout() // 레이아웃 구성
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
    
    // MARK: - 레이아웃
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
    
    // MARK: - 공통 버튼 생성 메서드
    private func createToggleButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 0 // 기본적으로 경계선 없음
        button.layer.borderColor = UIColor.clear.cgColor // 경계선 색상 없음
        button.clipsToBounds = true // 경계 클립 활성화
        button.tag = 0 // 기본 상태: 미선택
        
        // 모든 버튼의 상태 초기화
        button.transform = .identity
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
        let isSelected = button.tag == 1 // 태그로 선택 상태 확인
        
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) // 클릭 애니메이션
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = .identity // 원래 크기로 복원
            })
        })
        
        if isSelected {
            // 미선택 상태로 변경
            button.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1)
            button.setTitleColor(UIColor(red: 0.365, green: 0.373, blue: 0.404, alpha: 1), for: .normal)
            button.layer.borderWidth = 0 // 경계선 제거
            button.layer.borderColor = UIColor.clear.cgColor // 경계선 색상 초기화
            button.clipsToBounds = true // 버튼 경계 내 클립
            button.tag = 0 // 미선택 상태로 변경
        } else {
            // 선택 상태로 변경
            button.backgroundColor = UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 2 // 경계선 추가
            button.layer.borderColor = UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1).cgColor
            button.clipsToBounds = true // 버튼 경계 내 클립
            button.tag = 1 // 선택 상태로 변경
        }
    }
}
