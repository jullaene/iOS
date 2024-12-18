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
            make.leading.equalTo(latestFilterButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func addDogFilter(imageURL: String, name: String) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray200
        button.layer.cornerRadius = 18
        button.clipsToBounds = true

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        if let url = URL(string: imageURL), !imageURL.isEmpty {
            imageView.kf.setImage(with: url)
        } else {
            imageView.backgroundColor = .gray300
        }

        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray500

        // 텍스트 길이 동적 계산
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill

        button.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        button.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(stackView.snp.width).offset(32)
            make.height.equalTo(36)
        }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        dogFilterStackView.addArrangedSubview(button)
    }
}
