//
//  MatchingStatusApplicantDetailCell.swift
//  walkmong
//
//  Created by 신호연 on 1/9/25.
//

import UIKit
import SnapKit

final class MatchingStatusApplicantDetailCell: UIView {
    
    // MARK: - UI Components
    
    private let profileImageView = UIImage.createImageView(
        named: "profileExample",
        cornerRadius: 41
    )
    
    private let nameLabel = UpperTitleLabel(text: "", textColor: .gray600)
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필", for: .normal)
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let locationIcon = UIImage.createImageView(named: "meetingPlace", tintColor: .gray400)
    
    private let locationLabel = SmallMainHighlightParagraphLabel(text: "", textColor: .gray400)
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .gray100
        layer.cornerRadius = 20
        
        addSubviews(profileImageView, nameLabel, profileButton, locationIcon, locationLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(12)
            make.width.height.equalTo(82)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        profileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(profileImageView)
            make.width.equalTo(54)
            make.height.equalTo(25)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.height.equalTo(17)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Public Method
    func updateOwnerInfo(
        ownerProfile: String?,
        ownerName: String,
        ownerAge: Int,
        ownerGender: String,
        dongAddress: String,
        distance: Double
    ) {
        profileImageView.setImage(from: ownerProfile, placeholder: "profileExample")
        nameLabel.text = ownerName
        let genderText = ownerGender == "FEMALE" ? "여성" : "남성"
        locationLabel.text = "\(dongAddress)"
    }
    
    // MARK: - Helper Methods
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let distanceInKm = distance / 1000
            return distanceInKm == floor(distanceInKm) ? "\(Int(distanceInKm))km" : String(format: "%.1fkm", distanceInKm)
        }
    }
}
