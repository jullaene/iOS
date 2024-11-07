//
//  DropDownView.swift
//  walkmong
//
//  Created by 신호연 on 11/6/24.
//

import UIKit

protocol DropdownViewDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class DropdownView: UIView {
    
    weak var delegate: DropdownViewDelegate?
    
    private let locations = ["공릉동", "청담동"] // 선택 가능한 동네
    private var selectedLocation: String = "공릉동" // 기본 선택
    
    private let selectedLabel = UILabel()
    private let unselectedLabel1 = UILabel()
    private let settingsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateSelection(selectedLocation: selectedLocation) // 초기 상태 업데이트
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.backgroundColor = UIColor(red: 0.978, green: 0.978, blue: 0.978, alpha: 1).cgColor
        self.layer.cornerRadius = 20
        
        addSubview(selectedLabel)
        addSubview(unselectedLabel1)
        addSubview(settingsLabel)
        
        setupLabel(selectedLabel, text: "공릉동", isSelected: true)
        setupLabel(unselectedLabel1, text: "청담동", isSelected: false)
        setupLabel(settingsLabel, text: "동네 설정", isSelected: false)
        
        selectedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        unselectedLabel1.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(unselectedLabel1.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        let selectedTap = UITapGestureRecognizer(target: self, action: #selector(handleSelectedTap))
        selectedLabel.addGestureRecognizer(selectedTap)
        selectedLabel.isUserInteractionEnabled = true
        
        let unselectedTap = UITapGestureRecognizer(target: self, action: #selector(handleUnselectedTap))
        unselectedLabel1.addGestureRecognizer(unselectedTap)
        unselectedLabel1.isUserInteractionEnabled = true
    }
    
    private func setupLabel(_ label: UILabel, text: String, isSelected: Bool) {
        label.text = text
        label.textColor = isSelected
            ? UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1)
            : UIColor(red: 0.496, green: 0.508, blue: 0.557, alpha: 1)
        label.font = UIFont(name: "Pretendard-\(isSelected ? "SemiBold" : "Medium")", size: 16)
    }
    
    func updateSelection(selectedLocation: String) {
        self.selectedLocation = selectedLocation
        setupLabel(selectedLabel, text: locations[0], isSelected: selectedLocation == locations[0])
        setupLabel(unselectedLabel1, text: locations[1], isSelected: selectedLocation == locations[1])
    }
    
    @objc private func handleSelectedTap() {
        delegate?.didSelectLocation(locations[0])
    }
    
    @objc private func handleUnselectedTap() {
        delegate?.didSelectLocation(locations[1])
    }
}
