//
//  DropDownView.swift
//  walkmong
//
//  Created by 신호연 on 11/6/24.
//

import UIKit

class DropdownView: UIView {
    
    private let selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "공릉동"
        label.textColor = UIColor(red: 0.276, green: 0.754, blue: 1, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "공릉동", attributes: [
            .kern: -0.32,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()
    
    private let unselectedLabel1: UILabel = {
        let label = UILabel()
        label.text = "청담동"
        label.textColor = UIColor(red: 0.496, green: 0.508, blue: 0.557, alpha: 1)
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "청담동", attributes: [
            .kern: -0.32,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()
    
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "동네 설정"
        label.textColor = UIColor(red: 0.496, green: 0.508, blue: 0.557, alpha: 1)
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        label.attributedText = NSMutableAttributedString(string: "동네 설정", attributes: [
            .kern: -0.32,
            .paragraphStyle: paragraphStyle
        ])
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
        
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        unselectedLabel1.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            selectedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            selectedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            unselectedLabel1.topAnchor.constraint(equalTo: selectedLabel.bottomAnchor, constant: 12),
            unselectedLabel1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            unselectedLabel1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            settingsLabel.topAnchor.constraint(equalTo: unselectedLabel1.bottomAnchor, constant: 12),
            settingsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            settingsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            settingsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
