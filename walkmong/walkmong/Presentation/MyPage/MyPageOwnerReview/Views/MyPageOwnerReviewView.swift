//
//  MyPageOwnerReviewView.swift
//  walkmong
//
//  Created by 신호연 on 12/18/24.
//

import UIKit
import SnapKit
import Kingfisher

class MyPageOwnerReviewView: UIView {
    
    private let filterContainerView = UIView()
    private let latestFilterButton = UIButton.createStyledButton(type: .customFilter, style: .light, title: "최신순")
    private let dogFilterStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        filterContainerView.addSubview(latestFilterButton)
        addSubview(filterContainerView)
        
        dogFilterStackView.axis = .horizontal
        dogFilterStackView.spacing = 8
        dogFilterStackView.alignment = .center
        filterContainerView.addSubview(dogFilterStackView)
        
        addDogFilter(imageURL: "https://www.fitpetmall.com/wp-content/uploads/2022/11/shutterstock_196467692-1024x819.jpg", name: "봄별이")
        addDogFilter(imageURL: "", name: "새봄이")
    }
    
    private func setupConstraints() {
        filterContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(77)
        }
        
        latestFilterButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        dogFilterStackView.snp.makeConstraints { make in
            make.leading.equalTo(latestFilterButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func addDogFilter(imageURL: String, name: String) {
        let button = UIButton.createStyledButton(
            type: .homeFilter,
            style: .profile,
            title: name,
            imageUrl: imageURL
        )
        
        dogFilterStackView.addArrangedSubview(button)
    }
}
