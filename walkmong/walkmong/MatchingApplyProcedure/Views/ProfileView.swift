//
//  ProfileView.swift
//  walkmong
//
//  Created by 신호연 on 11/12/24.
//

import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func profileButtonTapped()
}

class ProfileView: UIView {
    
    // MARK: - Properties
    private weak var delegate: ProfileViewDelegate?

    // MARK: - UI Components
    private let topFrameView = UIView()
    
    private let nameLabel = ProfileView.createLabel(
        text: "봄별이",
        font: UIFont(name: "Pretendard-Bold", size: 28),
        textColor: UIColor.mainBlack,
        alignment: .left
    )
    
    private let femaleIconView = ProfileView.createImageView(named: "femaleIcon")
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 10
        button.setTitle("프로필", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let dogInfoLabel = ProfileView.createLabel(
        text: "소형견 · 말티즈 4kg · 4살",
        font: UIFont(name: "Pretendard-Regular", size: 16),
        textColor: .gray500
    )
    
    private let locationIconView = ProfileView.createImageView(named: "locationIcon")
    
    private let locationLabel = ProfileView.createLabel(
        text: "노원구 공릉동 1km",
        font: UIFont(name: "Pretendard-Regular", size: 14),
        textColor: .gray500
    )
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubviews()
        setupConstraints()
        setupActions()
    }
    
    private func addSubviews() {
        addSubview(topFrameView)
        topFrameView.addSubview(nameLabel)
        topFrameView.addSubview(femaleIconView)
        topFrameView.addSubview(profileButton)
        addSubview(dogInfoLabel)
        addSubview(locationIconView)
        addSubview(locationLabel)
    }
    
    private func setupConstraints() {
        topFrameView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(39)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        femaleIconView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.centerY.equalTo(nameLabel)
            make.size.equalTo(24)
        }
        
        profileButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 73, height: 34))
        }
        
        dogInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(topFrameView.snp.bottom).offset(12)
            make.leading.centerX.equalToSuperview()
        }
        
        locationIconView.snp.makeConstraints { make in
            make.top.equalTo(dogInfoLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.size.equalTo(14)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIconView)
            make.leading.equalTo(locationIconView.snp.trailing).offset(2)
        }
    }
    
    private func setupActions() {
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Public Methods
    func setDelegate(_ delegate: ProfileViewDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Actions
    @objc private func profileButtonTapped() {
        delegate?.profileButtonTapped()
    }
    
    // MARK: - Helper Methods
    private static func createLabel(text: String, font: UIFont?, textColor: UIColor, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        return label
    }
    
    private static func createImageView(named imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
